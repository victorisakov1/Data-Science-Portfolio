# Run this script from its own folder so the CSV files below are found.
getwd()
p_data <- read.csv('BankChurnDataset.csv')
head(p_data)
str(p_data)

#getting all the necessary packages
library(Amelia)
library(ggplot2)
library(dplyr)
library(caTools)
library(caret)

#Checking for missing values (Runs for too long as it is a heavy dataset. So not the best way in our case to plot the missing values, especially when the number of missing values is very low)
missmap(p_data, main="Bank Churn Training Data - Missings Map", 
        col=c("yellow", "black"), legend=TRUE)

ggplot(p_data,aes(Exited)) + geom_bar() #Counting how many people exited VS how many did not

ggplot(p_data,aes(Age)) + geom_histogram(fill='blue',bins=20,alpha=0.5) #Visualizing most common ages

pl <- ggplot(p_data,aes(Gender,Age)) + geom_boxplot(aes(group=Gender,fill=factor(Gender),alpha=0.4)) #checking for age distribution by gender
pl + scale_y_continuous(breaks = seq(min(0), max(80), by = 2))


sum(is.na(p_data)) #number of missing values in Dataset
colSums(is.na(p_data)) #where those values are missing - Age and EstimatedSalary
p_data[!complete.cases(p_data),] #which exact observations have missing variables

#finding median and further substituting missing ages with the Median (we choose median due to a variety of outliers and skewness to the right)
median_age <- median(p_data$Age, na.rm = TRUE)
p_data$Age[is.na(p_data$Age)] <- median_age


#checking for distribution of EstimatedSalary and seeing skewness to the left. 
#So, we are going to replace the missing values with the Median EstimatedSalary
ggplot(p_data,aes(EstimatedSalary)) + geom_histogram(fill='blue',bins=20,alpha=0.5)

median_EstSalary <- median(p_data$EstimatedSalary, na.rm = TRUE)
p_data$EstimatedSalary[is.na(p_data$EstimatedSalary)] <- median_EstSalary

#checking missing values again
any(is.na(p_data$EstimatedSalary))


#removing unwanted columns because they don't bring any value to the model:
#id, CutomerId, Surname
train <- select(p_data,-id,-CustomerId,-Surname)

str(train)

#changing Geography and Gender to Factors
train$Geography <- as.factor(train$Geography)
train$Gender <- as.factor(train$Gender)

#training model using Logistic Regression
log.model <- glm(formula=Exited ~ . , family = binomial(link='logit'),data = train)
summary(log.model)

#setting a seed
set.seed(111)


#splitting data into training and testing
split = sample.split(train$Exited, SplitRatio = 0.70)

final.train = subset(train, split == TRUE)
final.test = subset(train, split == FALSE)

final.log.model <- glm(formula=Exited ~ . , family = binomial(link='logit'),data = final.train)
summary(final.log.model)
str(final.log.model)

#checking the accuracy of the model 
fitted.probabilities <- predict(final.log.model,newdata=final.test,type='response')
fitted.results <- ifelse(fitted.probabilities > 0.5,1,0)

fitted.results
fitted.results != final.test$Exited

misClasificError <- mean(fitted.results != final.test$Exited) #Error of Missclassifications
print(paste('Accuracy',1-misClasificError)) #Printing our Model Prediction Accuracy

#Creating the Confusion Matrix
table(final.test$Exited, fitted.results)
str(final.train)

#Calculating Sensitivity using Confusion Matrix: The “true positive rate” – the percentage of individuals the model correctly predicted would default.
#Calculating Specificity using confusion matrix: The “true negative rate” – the percentage of individuals the model correctly predicted would not default.
final.test$Exited <- as.factor(final.test$Exited)
fitted.results <- as.factor(fitted.results)

sensitivity(final.test$Exited, fitted.results) #Sensitivity
specificity(final.test$Exited, fitted.results) #Specificity

#Model Accuracy: it will be working with an 83.4% Success Rate, which is a higher accuracy level.
#Model Specificity: in 69.8% of cases it correctly identified customers who didn't leave (did not churn), which is a moderate level of accuracy.
#Model Sensitivity: in 85.1% of cases it correctly identified customers who exited (churned), which is a higher level of accuracy.


#Now, we will use the second file with new customers to predict who will churn or not

n_data <- read.csv('NewCustomerDataset.csv')
str(n_data)
n_data[!complete.cases(n_data),] #which observations have missing variables (in our case there are no NA values)

#removing unnecessary columns
n_data <- select(n_data,-id,-CustomerId,-Surname)

#changing to Factor same columns as in the training dataset
n_data$Geography <- as.factor(n_data$Geography)
n_data$Gender <- as.factor(n_data$Gender)
str(n_data)

#And predicting the outcomes for the New Dataset
n_prob <- predict(final.log.model, newdata = n_data, type = 'response')
n_pred <- ifelse(n_prob > 0.5, 1, 0)

n_data$Exited <- ifelse(n_prob > 0.5, 1, 0)
sum(n_pred) #getting sum of people who would Churn from the new dataset

#Creating labels for a Pie chart
pred_labels <- c("Not Going to Churn", "Will Churn")
pred_counts <- table(n_pred)

#getting the percentages and labels
pred_percentages <- round(100 * pred_counts / sum(pred_counts), 1)
pred_labels_with_pct <- paste(pred_labels, "-", pred_percentages, "%")


#Mapping the Pie
pie(pred_counts, labels = pred_labels_with_pct,
    main = "Distribution of Churn Predictions", 
    col = c("lightgreen", "coral"),
    init.angle = 15, 
    border = "white")


#Creating summary for Age
summary_stats <- n_data %>%
  group_by(Exited) %>%
  summarise(
    Mean = mean(Age, na.rm = TRUE),
    Median = median(Age, na.rm = TRUE)
  )


# Print the summary statistics
print(summary_stats)


#As a result, we see that 11.7% will leave the bank and 88.3% are going to stay.
#Also, we found out that more younger people will stay, whereas older people will leave the bank.
#It could suggest that the Bank should assess needs of older people in order to keep the retention higher.