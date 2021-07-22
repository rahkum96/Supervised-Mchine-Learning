################################################################################
###############################################################################
########################## Regression Problem #################################


# Perform a predictive regression analysis on the provided 
#House_Price_Data in R-studio to arrive at the final model from where significant 
#variables can be summarized which play a vital role in determining the purchasing price 
#of the house. 

#The objective here is to help customers optimize their purchase of houses.

#Load the dataset
housing<- read.csv("C:\\Users\\Rohit Kumar (Prince)\\OneDrive\\Desktop\\Ivy_Data_science\\R-\\HW\\Linear_Regression_caseStudy\\House_Price_Data.csv", sep = ",", stringsAsFactors = T)
dim(housing) # it has 932 rows and 9 columns
colnames(housing)
str(housing)
class(housing)
head(housing)
summary(housing) # here we got the summary of each columns and also known that there is some missing data as well.


#Step-02 ------------      Data pre-processing


#a) To check missing values in data set
colSums(is.na(housing))

#Yes, we found in(Taxi_dist   Market_dist Hospital_dist   Carpet_area  Builtup_area)

#Percentage of missing values in each column
colSums(is.na(housing))/nrow(housing)# since missing value % is less than threshol) 

#To Check outliers 
boxplot(housing$Taxi_dist) #yes found, so we will fill tha missing values with median
m1<- median(housing$Taxi_dist,na.rm = T)
m1 # 8230

#Replace missing value with m1
housing$Taxi_dist[which(is.na(housing$Taxi_dist))]<- m1

boxplot(housing$Market_dist) # yes outliers found, fill the missing values with median
m2<- median(housing$Market_dist,na.rm = T)
m2 #11161

# Replacing the missing values with m2
housing$Market_dist[which(is.na(housing$Market_dist))]<- m2

boxplot(housing$Hospital_dist)# yes outliers found, fill the missing values with median
m3<- median(housing$Hospital_dist, na.rm = T)
housing$Hospital_dist[which(is.na(housing$Hospital_dist))]<- m3

boxplot(housing$Carpet_area)# yes outliers found, fill the missing values with median
m4<- median(housing$Carpet_area, na.rm = T)
housing$Carpet_area[which(is.na(housing$Carpet_area))]<- m4

boxplot(housing$Builtup_area) # yes outliers found, fill the missing values with median
m5<- median(housing$Builtup_area, na.rm = T)
housing$Builtup_area[which(is.na(housing$Builtup_area))]<- m5

colSums(is.na(housing)) 
################### missing values treatment done #############################

#b) we have to handle outliers as well.
#for handling outlier we are using Box plot.

#for columns
boxplot(housing$Taxi_dist)
quantile(housing$Taxi_dist,seq(0,1,0.01))
housing$Taxi_dist<- ifelse(housing$Taxi_dist>14000,14000,housing$Taxi_dist)#positive outliers 
housing$Taxi_dist<- ifelse(housing$Taxi_dist<2365,2365,housing$Taxi_dist) #-ve outliers hanndling

boxplot(housing$Market_dist)
quantile(housing$Market_dist,seq(0,1,0.01))
housing$Market_dist<- ifelse(housing$Market_dist>17017,17017,housing$Market_dist)#positive outliers 
housing$Market_dist<- ifelse(housing$Market_dist<5291,5291,housing$Market_dist) #-ve outliers hanndling

boxplot(housing$Hospital_dist)
quantile(housing$Hospital_dist,seq(0,1,0.005))
housing$Hospital_dist<- ifelse(housing$Hospital_dist>19765,19765,housing$Hospital_dist)#positive outliers 
housing$Hospital_dist<- ifelse(housing$Hospital_dist<6385,6385,housing$Hospital_dist) #-ve outliers hanndling

boxplot(housing$Carpet_area)
quantile(housing$Carpet_area,seq(0,1,0.01))
housing$Carpet_area<- ifelse(housing$Carpet_area>2038,2038,housing$Carpet_area)#positive outliers 
housing$Carpet_area<- ifelse(housing$Carpet_area<923,923,housing$Carpet_area) #-ve outliers hanndling

boxplot(housing$Builtup_area)
quantile(housing$Builtup_area,seq(0,1,0.01))
housing$Builtup_area<- ifelse(housing$Builtup_area>2418,2418,housing$Builtup_area)#positive outliers 
housing$Builtup_area<- ifelse(housing$Builtup_area<1110,1110,housing$Builtup_area) #-ve outliers hanndling

################### outliers treatments done ##############################
################################################################################

#Step-03 -------------------> Data visualization

#### Explore each "Potential" predictor for distribution and Quality
####Uni variate analysis

##continuous column- histogram
##categorical column- bar plot

# Exploring MULTIPLE CONTINUOUS features
names(housing)
hist_cols<-c("Taxi_dist","Market_dist","Hospital_dist", "Carpet_area","Builtup_area", "Rainfall","Price_house" )

#splitting the plot window into 2 parts
par(mfrow=c(2,4))

# library to generate professional colors
library(RColorBrewer) 

for(i in hist_cols){
  hist(housing[,i],main=paste("Histogram of:",i),
       col=brewer.pal(8,"Paired"))
}

# Exploring MULTIPLE CATEGORICAL features
bar_cols<- c("Parking_type","City_type")

#splitting the plot window into 2 parts
par(mfrow=c(2,3))

for(i in bar_cols){
  barplot(table(housing[,i]),main=paste("Bar Plot Of:",i),
                col= brewer.pal(8,"Paired"))
}

##bivariate analysis

# Visual Relationship between predictors and target variable
##Regression- 2 scenarios
# Continuous Vs Continuous ---- Scatter Plot
# Continuous Vs Categorical --- Box Plot

# Continuous Vs Continuous --- Scatter plot

# For multiple columns at once
cont_cols<- c("Taxi_dist","Market_dist","Hospital_dist", "Carpet_area","Builtup_area", "Rainfall","Price_house" )
par(mfrow=c(2,4))
for(box_cols in cont_cols){
  boxplot(housing[  ,c(box_cols)], data=housing  , main=paste('Boxplot of :',box_cols), horizontal = T,col=brewer.pal(8,"Paired"))
}

# Continuous Vs Categorical Visual analysis: Boxplot

cat_cols<- c("Parking_type","City_type")

#splitting the plot window into 2 parts
par(mfrow=c(2,3))
library(RColorBrewer)
for(i in cat_cols){
  boxplot(Price_house~(housing[,i]),data = housing,
          main=paste("Box olot Of:",i),
          col= brewer.pal(8,"Paired"))
}

#Strength of Relationship between predictor and target variable
# Continuous Vs Continuous ---- Correlation test
# Continuous Vs Categorical---- ANOVA test

# Continuous Vs Continuous : Correlation analysis
# Correlation for multiple columns at once

cont_corr<- c("Taxi_dist","Market_dist","Hospital_dist", "Carpet_area","Builtup_area", "Rainfall","Price_house" )

corrdata<-cor(housing[,cont_corr], use = "complete.obs")
corrdata

##cont_cols is not good variables for target variables we will remove all these columns

#############################################################################

# Continuous Vs Categorical correlation strength: ANOVA
# Analysis of Variance(ANOVA)

# H0: Variables are NOT correlated
# Small P-Value--> Variables are correlated(H0 is rejected)
# Large P-Value--> Variables are NOT correlated (H0 is accepted)
# Using a for-loop to perform ANOVA on multiple columns
cat_corr_ANOVA<- c("Parking_type","City_type")


for (i in cat_corr_ANOVA){
  test_summary=summary(aov(Price_house ~ housing[,i], data = housing))
  print(paste("The Anova test with",i))
  print(test_summary)
}

#"Parking_type","City_type"- are good coorelated 

#Choosing multiple Predictors which may have relation with Target Variable
# Based on the exploratory data analysis

housing<- housing[,c("Parking_type","City_type","Price_house")]
str(housing)
class(housing)
head(housing)


###############################################################################
###############################################################################

#Library for splitting the test and training data
library(caTools)

#splitting the training and testing data
set.seed(900)

# Sampling | Splitting data into 80% for training 20% for testing
split<- sample.split(housing$Price_house,SplitRatio = 0.80)
table(split)

training<- subset(housing,split==T) # True - Training data
testing<- subset(housing,split==F) #False_ testing data set

# Creating Predictive models on training data to check the accuracy of each algorithm
###### Linear Regression #######

lin_model<- lm(Price_house~.,data = training)
summary(lin_model)

 
#Adjusted R-squared:  0.4659 our model accuracy is ~47% 

#Adjusted R-squared: it will considered only statistically  significance variable 
#Multiple R-squared: it will considered both statistically significance as well as non statistically significance 


###############################################################################
###############################################################################

#checking the assumptions
#1 no autocorrelation
library(lmtest)
library(faraway)
library(car)
dwtest(lin_model) 
#DW = 1.95, Here our Dw value lies between 0 and 4, so we could say 
#there is no autocorrelation, if Dw value <0 and >4 then, we will go with time series forecasting
durbinWatsonTest(lin_model)


#2 no multicollinearity
vif(lin_model) 
# there is no multicollinearity, because our vif(variance infuelce factor is less tha 5) 

#3 There should not hetroscadicity : it means outliers treatements 

#4 choose right endogenity; it means we have to select right target varibale


###############################################################################
################################################################################

##You have the Target variable, predicted by all other predictors intraining data
pred<- predict(lin_model, newdata = testing)
summary(pred)

# now going to see predicted price vs actual price 

price_pred<- cbind(testing$Price_house,pred)

head(price_pred)

#we are getting model accuracy to ~47%


################################################################################
############################## Decision Tree ###############################


#as in my stem it doesn't take automatically factor so 
#i have converted then read all the data again

#Building decision tree model by using "rpart"
library(rpart)

##beauty of decision tree is that: even if you pass 20 variables, it will use only
#those variables which are useful in prediction, and it will simply ignore
#other variables.
#It is doing automatic feature selection, based on the concept we have discussed
##DT will choose those variables only which are helping to bifurcate

dtree<- rpart(Price_house~.,data = training)
summary(dtree)

#Plot the dtree
plot(dtree)

text(dtree)


###### WE wanted to see fancy plot for decision tree #########################
library(rattle)

fancyRpartPlot(dtree)


head(housing)
head(testing)

####Now we have to predict the model#################
##You have the Target variable, predicted by all other predictors in training data
dtree_pred<- as.numeric (predict(dtree, newdata =testing))
head(dtree_pred)
head(testing$Price_house)

errorInModel= 100 *(abs(testing$Price_house-dtree_pred)/testing$Price_house)

##we can see for each prediction what is the error I am committing
##for average accuracy: we take the average of all the errors and subtract it from 100

print(paste('### Mean Accuracy of Decision tree Model is: ', 100 - mean(errorInModel)))
print(paste('### Median Accuracy of Decision tree Model is: ', 100 - median(errorInModel)))

"### Mean Accuracy of Decision tree Model is:  79.8695036128235"

"### Median Accuracy of Decision tree Model is:  85.0831283656623"

