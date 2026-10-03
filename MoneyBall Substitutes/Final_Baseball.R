# Run this script from its own folder so the CSV files below are found.
getwd()

library(dplyr)
library(ggplot2)

batting <- read.csv("Batting.csv")
salaries <- read.csv("Salaries.csv")

head(batting)
str(batting)


#Batting Average(BA): AVG = H/AB   H:Hits, AB:At Bats
batting <- batting %>% mutate(BA = H/AB)
#On Base Percentage(OBP): OBP=(H+BB+HBP)/(AB+BB+HBP+SF)   H:Hits, BB:Bases on Balls (Walks), HBP:Hit By Pitch, AB:At bat, SF:Sacrifice fly
batting <- batting %>% mutate(OBP = (H+BB+HBP)/(AB+BB+HBP+SF))
#Singles
batting <- batting %>% mutate(X1B = H - X2B - X3B - HR)
#Slugging Percentage
batting <- batting %>% mutate(SLG = (X1B + (2*X2B) + (3*X3B) + (4*HR))/AB)

#Choosing only 2001-02 for Batting & Salaries (for comparison and further choices)
rel_bat <- subset(batting, yearID == 2001 | yearID ==2002)
rel_sal <- subset(salaries, yearID == 2001 | yearID ==2002)

#Merging data
comb_data <- merge(rel_bat, rel_sal, by = c("playerID", "yearID","teamID","lgID"),all = TRUE)
colSums(is.na(comb_data)) #finding NA values

#First we have to handle with NA values
#As salary a critic criterium, we will not impute salary and delete the rows where salary is NA.
comb_data<-comb_data[complete.cases(comb_data$salary),]
rowSums(is.na(comb_data)) #finding NA values

#Second, we handle NA values for the playing statistics by replacing it to zero values. 
#It might be reasonable because not participating or the lack of recorded data could logically result in a count of 0 for these statistics.
comb_data <- comb_data %>%
  mutate(
    BA = if_else(is.na(BA), 0, BA),
    OBP = if_else(is.na(OBP), 0, OBP), 
    SLG = if_else(is.na(SLG), 0, SLG))

rowSums(is.na(comb_data)) #finding NA values left

#Assuming comb_data is your actual dataframe
na_matrix <- is.na(comb_data)

#Creating the Dataframe with rows that contain at least one NA
rows_with_na <- comb_data[rowSums(na_matrix) > 0, ]

#After carefully analyzing the dataset, we have learnt that rows with NA values have at least 17 missing values.
#So we decided to exclude them from the further analysis





#___________________OUTFIELDER SELECTION____________________
#Creating a composite metric for performance which is an average of selected statistics
potential_players <- comb_data %>%
  mutate(perf_metric = (BA + OBP + SLG) / 3, perf_per_salary = perf_metric / salary)

#Organizing the players with the highest performance_per_salary
most_valuable_outfielders <- potential_players %>% 
  arrange(desc(perf_per_salary))

most_valuable_outfielders <- most_valuable_outfielders %>% filter(most_valuable_outfielders$yearID == 2002)

outfielder_replace<- head(most_valuable_outfielders)

#creating a dataframe to subset the most preferred two replacement candidates and the outgoing outfielder
outf_comp <- subset(most_valuable_outfielders, playerID== "damonjo01" | playerID == "spiveju01" | playerID == "hinsker01")

#Comparison by OBP for outfielder
g <-ggplot(data=outf_comp, aes(x=salary,y=OBP,
                               colour=playerID)) + 
  xlab("Salary") +
  ylab("On Base Percentage") +
  ggtitle("OBP Comparison by Player (Outfielder)")

g + geom_point(size=6)

#Comparison by BA for outfielder
p <-ggplot(data=outf_comp, aes(x=salary,y=BA,
                               colour=playerID))+ 
  xlab("Salary") +
  ylab("Batting Average") +
  ggtitle("BA Comparison by Player (Outfielder)")
p + geom_point(size=6)


#Comparison by perf_metric for outfielder
o <-ggplot(data=outf_comp, aes(x=salary,y=perf_metric,
                               colour=playerID))+ 
  xlab("Salary") +
  ylab("Performance Metric") +
  ggtitle("Performance Comparison by Player (Outfielder)")
o + geom_point(size=6)

#After reviewing the outfielder_replace DataFrame we conclude that
#spiveju01 is our most valuable outfielder. hinsker01 is our second choice as his Performance Metrics are a bit lower.





#___________________MVP SELECTION____________________

# Jason Giambi - MVP
Jason_Giambi <- subset(comb_data, playerID %in% c('giambja01'))
Jason_Giambi

# Replacement player to look for:
#In order to find the replacement MVP players, we need to filter and rearrange data following 2 constraints:
#1. The salary of the players cannot be greater than Jason Giambi.
#2. The OBP, SLG, HR, and RBI better to equal to or greater than Jason Giambi.

# In 2001
Jason_Giambi <- subset(Jason_Giambi, yearID == 2001)
Jason_Giambi <- Jason_Giambi[,c('playerID', 'OBP', 'SLG', 'HR', 'RBI', 'salary')]
head(Jason_Giambi)

avail.players <- filter(comb_data, yearID == 2001)
avail.players_1 <- filter(avail.players, OBP >= 0.47, SLG >= 0.65 , HR >= 38, RBI >= 120)
possible_1 <- head(arrange(avail.players_1, desc(salary)), 10)
possible_1 <- possible_1[,c('playerID', 'OBP', 'SLG', 'HR', 'RBI', 'salary')]
possible_1
#As we can see,  "bondsba01" is the only one who has higher OBP, SLG, HR, and RBI than Jason Giambi,
#but his salary was beyond the budget.

# If we look at someone who's salary equal to or a bit less than the Jason Giambi and with relatively good OBP, SLG, HR, and RBI performance:
avail.players_2 <- filter(comb_data, yearID == 2001)
avail.players_2 <- filter(avail.players_2, salary <= 4103333, OBP >= 0.4, SLG >= 0.6 , HR >= 30, RBI >= 100)
possible_2 <- head(arrange(avail.players_2, desc(OBP)), 10)
possible_2 <- possible_2[,c('playerID', 'OBP', 'SLG', 'HR', 'RBI', 'salary')]
possible_2

#creating a dataframe to subset the most preferred two replacement candidates and the outgoing MVP
mvp_comp <- subset(possible_2, playerID== "giambja01" | playerID == "berkmla01" | playerID == "pujolal01")

#Comparison by OBP for MVP
n <-ggplot(data=mvp_comp, aes(x=salary,y=OBP, 
                              colour=playerID))+ 
  xlab("Salary") +
  ylab("On Base Percentage") +
  ggtitle("OBP Comparison by Player (MVP)")
n + geom_point(size=6)

#If we looking for someone we can afford,
#berkmla01 is our Top MVP substitute candidate, and pujolal01 is second best.
#Since they had the highest on-base percentage and their salaries are lower than "Jason Giambi".





#___________________CLOSER SELECTION____________________

#Earned Run Average (ERA): 9 x earned runs (ER) / innings pitched (IP) w/ assumptions
closer <- comb_data %>% mutate(IP = (H+BB/3)+SO ) # Calculating Innings Pitched
closer <- closer %>% mutate(RA = H+BB-SO+HR) #Calculation of Runs Allowed 
closer <- closer %>% mutate(ERA = (9*RA)/IP)
# Why is this important? ------
#Used to evaluate a pitcher's performance and effectiveness in preventing runs, which is ultimately the goal of pitching.
# BB/9 
closer <- closer %>% mutate(BB_9 = (BB/IP)*9)

# Why is this important?----
#For pitchers, especially relief pitchers like closers, minimizing walks is 
#essential to prevent free base-runners and potential scoring opportunities for the opposing team. 
#A low BB/9 indicates better control and command of pitches.


#Closer :D
closers_data <- closer[c("playerID", "yearID", "teamID","OBP", "SLG","BB_9", "SO", "ERA", "salary")]
#Adding Composite Score
closers_data$Composite_Score <- with(closers_data, {
  ifelse(ERA != 0, (OBP + SLG - BB_9 + SO) / ERA, NA)
})
# Why is this important?-----
#Single metric that to evaluate the performance of closers


#--------
ranked_closers <- closers_data[order(-closers_data$Composite_Score), ]
ranked_closers
# top 10 candidates 
top_10 <-head(ranked_closers)
top_<- top_10[ranked_closers$yearID == '2002',] #Filtering by year since the closer left on 2002
clean_top <- na.omit(top_) #cleaning data! 

clean <- rbind(ranked_closers[ranked_closers$yearID == "2002" & ranked_closers$playerID == "saenzol01",])
final <- rbind(clean_top, clean)
#Based on salary & 2002 - entering: 
#Vectors based on top_10 ---- 
top_pick <- clean_top[clean_top$playerID == 'mcewijo01',]$playerID
second <- clean_top[clean_top$playerID == 'bergepe01',]$playerID

#creating a dataframe to subset the most preferred two replacement candidates and the outgoing closer
closer_comp <- subset(final, playerID== "saenzol01" | playerID == "mcewijo01" | playerID == "bergepe01")


#Comparison by composite score for closer
p <-ggplot(data=closer_comp, aes(x=salary,y=Composite_Score, 
                                 colour=playerID))+ 
  xlab("Salary") +
  ylab("Composite Score") +
  ggtitle("Composite Score by Player (Closer)")
p + geom_point(size=6)


# Insights----------

## With the stats given, the composite score is a combination of 
# offensive metrics (OBP and SLG), defensive metrics (BB_9 and ERA), and 
# strikeout ability (SO). So, the higher composite score indicates better 
#performance since it represents a pitcher who prevents batters from reaching base 
#(low OBP and SLG), limits walks (low BB_9), strikes out batters effectively, 
#and prevents earned runs (low ERA). 
#Therefore, the top 2 players are in the top 10 based on the composite score,
#however, we also selected players with good stats in 2002 (recruiting year for 
#the position) and their previous salaries. 



#__________________CONCLUSION_______________________________
#Overall our strategy was very simple yet effective: 
#1. To understand important characteristics for each player's Position.
#2. To define needed metrics where necessary.
#3. Create composite metrics to evaluate performance where necessary (in our case for Outfielder and Closer).
#4. Evaluate characteristics of the players who left.
#5. Find substitutes who have equal or lower Salary to those 3 players (separetely due to their differences). 
#And we decided to get players who are not more expensive as other costs will occur due to players substitutions:
#Transfer fees, Relocation Expenses, Training, Lost Revenue, Legal costs, and potentially more.
#6. And get the Top Performing players based on previous metrics.
#7. Finally, we selected TOP-2 Substitute players to propose.
#8. In addition, we provided Final Players Visualizations Comparisons (for each Position): Proposed VS Previous.
#9. It allows our stakeholders to see the current performance of those players.
