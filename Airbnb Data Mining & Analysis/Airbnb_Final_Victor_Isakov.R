#installing and loading the mongolite library to download the Airbnb data
#install.packages("mongolite") #need to run this line of code only once and then you can comment out

#Importing libraries that will be used
library(mongolite)
library(shiny)
library(tidyverse)
library(tidytext)
library(ggplot2)
library(igraph)
library(ggraph)
library(topicmodels)
library(scales)
library(Matrix)
library(textdata)
library(stringr)
library(dplyr)
library(tidyr)


# This is the connection_string. You can get the exact url from your MongoDB cluster screen
# Set MONGO_URL in your environment (or in ~/.Renviron) to your own cluster's URL, for example:
# mongodb+srv://<user>:<password>@<server_name>/
connection_string <- Sys.getenv("MONGO_URL")
airbnb_collection <- mongo(collection="listingsAndReviews", db="sample_airbnb", url=connection_string)

#Here's how you can download all the Airbnb data from Mongo
## keep in mind that this is huge and you need a ton of RAM memory

airbnb_all <- airbnb_collection$find()

#Changing 'description' to 'text' column (to follow industry standards)
colnames(airbnb_all)[5] <- "text"


#I decided to target United States Airbnb market to uncover some valuable insights
airbnb_usa <- airbnb_all %>%
  filter(address$country== "United States")

#And compare it to Australia Airbnb differences
airbnb_aus <- airbnb_all %>%
  filter(address$country == 'Australia')


#tokenizing text column and removing stop words to remove noise
data(stop_words)

tidy_usa <- airbnb_usa%>%
  unnest_tokens(word, text)%>%
  anti_join(stop_words)

tidy_aus <- airbnb_aus%>%
  unnest_tokens(word, text)%>%
  anti_join(stop_words)

#############################################
####We want to combine all the datasets and do frequencies 
#############################################
frequency <- bind_rows(mutate(tidy_usa, author="United States"),
                       mutate(tidy_aus, author= "Australia"),
)%>%#closing bind_rows
  mutate(word=str_extract(word, "[a-z']+")) %>%
  count(author, word) %>%
  group_by(author) %>%
  mutate(proportion = n/sum(n))%>%
  select(-n) %>%
  spread(author, proportion) %>%
  gather(author, proportion, `Australia`)

#Plotting visuals correlograms:
library(scales)
ggplot(frequency, aes(x=proportion, y=`United States`, 
                      color = abs(`United States`- proportion)))+
  geom_abline(color="grey40", lty=2)+
  geom_jitter(alpha=.1, size=2.5, width=0.3, height=0.3)+
  geom_text(aes(label=word), check_overlap = TRUE, vjust=1.5) +
  scale_x_log10(labels = percent_format())+
  scale_y_log10(labels = percent_format())+
  scale_color_gradient(limits = c(0,0.001), low = "darkslategray4", high = "gray75")+
  facet_wrap(~author, ncol=2)+
  theme(legend.position = "none")+
  labs(y= "United States", x=NULL)


cor.test(data=frequency[frequency$author == "Australia",],
         ~proportion + `United States`)

#Analysis of correlations:
#>Based on the correlation visualizations, we see that Australian and US Airbnb
#>description section is 95% alike. Which means that management can create very similar
#>advertisement campaigns. But in the US, they can propose to home owners to understand
#>that most visitors might be going to the vacations there compared to Australian market.
#>They should also evaluate the attention in the description regarding the neighborhood.
#>At the same time in Australia, home owners may get more benefits when covering sightseeing
#>like their famous Opera and Hills.
#>While these insights are not very unique, they still provide business value and should
#>be used for the benefits of the company and it's communication with homeowners.



#Now, let's focus on the n-grams
#Starting with bigrams
bigram_usa <- airbnb_usa %>%
  unnest_tokens(bigram, text, token = "ngrams", n=3) %>%
  separate(bigram, c("word1", "word2"), sep=" ") %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)


bigram_usa_united <- bigram_usa %>%
  unite(bigram, word1, word2, sep=" ") #we need to unite what we split in the previous section

bigram_usa_tf_idf <- bigram_usa_united %>%
  count(review_scores$review_scores_rating, bigram) %>%
  bind_tf_idf(bigram, review_scores$review_scores_rating, n) %>%
  arrange(desc(tf_idf))

bigram_usa_tf_idf


library(igraph)
bigram_graph <- bigram_usa_tf_idf %>%
  filter(n>10) %>%
  graph_from_data_frame()

bigram_graph

#>In our case, tf_idf didn't show significant insights and might need a 
#>deeper dive into it to uncover valuable insights.

#install.packages("ggraph")
library(ggraph)
ggraph(bigram_graph, layout = "fr") +
  geom_edge_link()+
  geom_node_point()+
  geom_node_text(aes(label=name), vjust =1, hjust=1)

#>The following visualization of USA airbnb bigrams shows that most of the
#>high frequency points are related to the amenities of the properties.
#>It doesn't show really insightful information that we didn't expect to see,
#>so we are moving further.


#Now, let's do sentiment analysis

afinn <- tidy_usa %>%
  inner_join(get_sentiments("afinn"))%>%
  summarise(sentiment=sum(value)) %>%
  mutate(method="AFINN")

bing_and_nrc <- bind_rows(
  tidy_usa%>%
    inner_join(get_sentiments("bing"))%>%
    mutate(method = "Bing et al."),
  tidy_usa %>%
    inner_join(get_sentiments("nrc") %>%
                 filter(sentiment %in% c("positive", "negative"))) %>%
    mutate(method = "NRC")) %>%
  count(method,  sentiment) %>%
  spread(sentiment, n, fill=0) %>%
  mutate(sentiment = positive-negative)



bind_rows(afinn, bing_and_nrc) %>%
  ggplot(aes(method, sentiment, fill=method))+
  geom_col(show.legend=FALSE)+
  facet_wrap(~method, ncol =1, scales= "free_y")



#>Now let's focus on sentiment analysis in Australia
afinn_aus <- tidy_aus %>%
  inner_join(get_sentiments("afinn"))%>%
  summarise(sentiment=sum(value)) %>%
  mutate(method="AFINN")

bing_and_nrc_aus <- bind_rows(
  tidy_aus%>%
    inner_join(get_sentiments("bing"))%>%
    mutate(method = "Bing et al."),
  tidy_aus %>%
    inner_join(get_sentiments("nrc") %>%
                 filter(sentiment %in% c("positive", "negative"))) %>%
    mutate(method = "NRC")) %>%
  count(method,  sentiment) %>%
  spread(sentiment, n, fill=0) %>%
  mutate(sentiment = positive-negative)


#Plotting the visual
bind_rows(afinn_aus, bing_and_nrc_aus) %>%
  ggplot(aes(method, sentiment, fill=method))+
  geom_col(show.legend=FALSE)+
  facet_wrap(~method, ncol =1, scales= "free_y")


#>The visual of Sentiment analysis can be confusing, because it uses 3 different 
#>sentiment analysis algorithms with their own scales.
#>Overall, it might represent a positive scale which would be an expected outcome
#>as negative sentiment in Airbnb listings descriptions would not be helpful and
#>would not be marketable to clients.



#USA Best and Worst sentiment words
bing_counts <- tidy_usa %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

bing_counts

# Now plot the top 10 positive and negative words
bing_counts %>%
  group_by(sentiment) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(y = "Contribution to sentiment", x = NULL) +
  coord_flip()


#Australia Best and Worst sentiment words
bing_counts_aus <- tidy_aus %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

bing_counts_aus

# Now plot the top 10 positive and negative words
bing_counts_aus %>%
  group_by(sentiment) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(y = "Contribution to sentiment", x = NULL) +
  coord_flip()

#These visuals help to better understand most frequent positive and negative



#list of sentiment words from the previous analysis (both positive and negative)
sentiment_words_usa <- c("complex", "retreat", "noise", "stall", "sink", 
                         "split", "hang", "fall", "cold", "hard", 
                         "beautiful", "enjoy", "quiet", "free", 
                         "spacious", "comfortable", "clean", "perfect", "easy", "love")

#creating a filter for United States DF for the sentiment words
sentiment_words_df <- tidy_usa %>%
  filter(word %in% sentiment_words_usa)

#calculating the average rating for listings containing each sentiment word
average_ratings <- sentiment_words_df %>%
  group_by(word) %>%
  summarise(avg_rating = mean(review_scores$review_scores_rating, na.rm = TRUE)) %>%
  ungroup()

#Plotting the average rating
ggplot(average_ratings, aes(x = word, y = avg_rating, fill = word)) +
  geom_col() +
  coord_flip() +
  labs(y = "Average Rating", x = "Word", title = "Average Rating for Listings with Sentiment Words (USA)") +
  theme(legend.position = "none")



sentiment_words_aus <- c("beautiful", "enjoy", "quiet", "free", 
                         "spacious", "comfortable", "clean", "perfect", 
                         "easy", "love", 
                         "hard", "cold", "fall", "hang", 
                         "split", "sink", "stall", "noise", 
                         "complex", "retreat")

#creating a filter for Australia DF for the sentiment words
sentiment_words_df_aus <- tidy_aus %>%
  filter(word %in% sentiment_words_aus)

#calculating the average rating for listings containing each sentiment word
average_ratings_aus <- sentiment_words_df_aus %>%
  group_by(word) %>%
  summarise(avg_rating = mean(review_scores$review_scores_rating, na.rm = TRUE)) %>%
  ungroup()

#Plotting the average rating
ggplot(average_ratings_aus, aes(x = word, y = avg_rating, fill = word)) +
  geom_col() +
  coord_flip() +
  labs(y = "Average Rating", x = "Word", title = "Average Rating for Listings with Sentiment Words (AUS)") +
  theme(legend.position = "none")


#>I have discovered a very important fact. That the most positive and the most
#>negative words don't affect rating of the listing. It shows that people look
#>beyond descriptions and care about other more valuable things.



#Now, let's apply DTM to the dataframes and analyze it though LDA


#Let's start with USA
tidy_usa <- tidy_usa %>%
  mutate(document_id = row_number())
dtm_usa <- tidy_usa %>%
  count(document_id, word) %>%
  cast_dtm(document = document_id, term = word, value = n)

ap_lda_usa <- LDA(dtm_usa, k=10, control=list(seed=123))
ap_lda_usa
topics_usa <- tidy(ap_lda_usa)

top_terms_USA <- topics_usa %>%
  group_by(topic) %>%
  top_n(5, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

top_terms_USA


# Let's plot the term frequencies by topic
top_terms_USA %>%
  group_by(term) %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~topic, scales = "free_y") +
  scale_x_reordered() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  coord_flip()


#Let's move to Australia
tidy_aus <- tidy_aus %>%
  mutate(document_id = row_number())
dtm_aus <- tidy_aus %>%
  count(document_id, word) %>%
  cast_dtm(document = document_id, term = word, value = n)

ap_lda_aus <- LDA(dtm_aus, k=10, control=list(seed=123))
ap_lda_aus
topics_aus <- tidy(ap_lda_aus)

top_terms_AUS <- topics_aus %>%
  group_by(topic) %>%
  top_n(5, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

top_terms_AUS

# Let's plot the term frequencies by topic
top_terms_AUS %>%
  group_by(term) %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~topic, scales = "free_y") +
  scale_x_reordered() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  coord_flip()
