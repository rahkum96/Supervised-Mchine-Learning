###############################################################################
################################ Linear regression problem #####################
######################### Anime_rating dataset case study ######################
#Step-1.
#In this dataset we have to predict the average Anime ratining given by the user 
#Step-2.
# load the dataset
anime_dataset<- read.csv("C:\\Users\\Rohit Kumar (Prince)\\OneDrive\\Desktop\\Ivy_Data_science\\R-\\HW\\Anime_rating_dataset\\Anime_Final.csv.csv")
#Lets check the first 6 rows of dataset
head(anime_dataset)
# Lets check the dimession;
dim(anime_dataset) #we have 7029 rows and 16 variables 
#Lets look at the variabes names;
names(anime_dataset)
#Lets see the structure of the anime_dataset;
str(anime_dataset)
#lets see the summary 
summary(anime_dataset)

###############################################################################
#Step-3.
#As we have seen in anime_dataset, many variables datatype is charater which is 
#not going help to predict the rating, so we will remove the useless column

#lets look at which column are useless;
lapply(anime_dataset,function(x)length(unique(x)))

#title:7029,description:3923,studios:532,tags:4869,contentWarn:131 These all are
#charater datatype and 

#useless_cols = C("title","description","studios","tags","contentWarn")
anime_dataset<- anime_dataset[,-c(1,7,8,9,10)]
#now lets look again structure of anime_dataset:
str(anime_dataset)
#lets move some variables to factor 
factor_cols<- c("mediaType","ongoing","sznOfRelease")
# we will use loop to convert factor_cols in factors
for(i in factor_cols){
  anime_dataset[,i]<- as.factor(anime_dataset[,i])
}
#now again lets look at structure 
str(anime_dataset)

###############################################################################
#Step-04
#data pre-processing
#a) check the missing values in dataset
colSums(is.na(anime_dataset))
#duration:1696,watched:87 missing values 
#Lets visualize the missing value;
#we will install the package "Amelia", I have already installed it.
library(Amelia)
missmap(anime_dataset, main="anime_dataset-Missing dataset Finding",
        col=c("red", "black"), legend = F)
#let find how much percent data are missing in these columns
colSums(is.na(anime_dataset))/nrow(anime_dataset)
#We will remove column duration which has more than 24% of missing data:
anime_dataset$duration<-NULL
#now we will fill the missing values in watched column
anime_dataset$watched[which(is.na(anime_dataset$watched))]<-round(mean(anime_dataset$watched,na.rm = T),0)
#now lets check again missing values
colSums(is.na(anime_dataset))
############################ Missing value treatments done ####################
#b)lets check the outliers in data set:
#lets check the column eps, we will use boxplot to see the outliers
boxplot(anime_dataset$eps)# yes we found, I am considering above 300 is outliers
#because most of data are between 0 and 300
quantile(anime_dataset$eps,seq(0,1,0.001))
anime_dataset$eps<- ifelse(anime_dataset$eps>300,300,anime_dataset$eps)
#lets check the column "watched"
boxplot(anime_dataset$watched)
quantile(anime_dataset$watched,seq(0,1,0.001))
anime_dataset$watched<- ifelse(anime_dataset$watched>60000,60000,anime_dataset$watched)
#lets check the column 'watching'
boxplot(anime_dataset$watching)
quantile(anime_dataset$watching,seq(0,1,0.001))
anime_dataset$watching<- ifelse(anime_dataset$watching>14341,14341,anime_dataset$watching)
#lets check the column"wantWatch"
boxplot(anime_dataset$wantWatch)
quantile(anime_dataset$wantWatch,seq(0,1,0.001))
anime_dataset$wantWatch<- ifelse(anime_dataset$wantWatch>19520,19520,anime_dataset$wantWatch)
#Now lets check the column"dropped"
boxplot(anime_dataset$dropped)
quantile(anime_dataset$dropped,seq(0,1,0.001))
anime_dataset$dropped<- ifelse(anime_dataset$dropped>4327,4327,anime_dataset$dropped)
#Now lets check the column"rating"
boxplot(anime_dataset$rating)#Not found
#Now lets check the column"votes"
boxplot(anime_dataset$votes)
quantile(anime_dataset$votes,seq(0,1,0.001))
anime_dataset$votes<- ifelse(anime_dataset$votes>48484,48484,anime_dataset$votes)

#################### Outliers Treatments done ##################################
#c)Encoding concept already done
#d)Feature scalling 

###############################################################################
#step-05
# Univariate and Bivariate Analysis

#Univariate Analysis;
#for continuous variables we will plot it by histogram graph
#for categorical variables  we will plot it by bar graph

# we will install the packages 
library(RColorBrewer)
library(ggplot2)
# Exploring MULTIPLE CONTINUOUS features
Hist_cols<- c("eps","watched","watching","dropped","rating","votes")
#splitting the plot window into 2 parts
par(mfrow=c(2,3))

for(i in Hist_cols){
  hist(anime_dataset[,c(i)],main = paste("Histogram of:",i),
       col = brewer.pal(8,"Paired"))
}

# Exploring MULTIPLE CATEGORICAL features
bar_cols<- c("mediaType","ongoing","sznOfRelease")
#Splitting the plot window into 2 parts
par=(mfrow=c(2,3))
for (i in bar_cols){
  barplot(table(anime_dataset[,c(i)]),main = paste("Barplot of:",i),
          col = brewer.pal(8,"Paired"))
}
#Data visualization each categorical columns:
qplot(anime_dataset$mediaType,geom = "bar",fill=I("blue"))
qplot(anime_dataset$sznOfRelease,geom = "bar", fill=I("red"),
      xlab = "season Release",
      ylab = "no of count",
      main= "season of Release in anime_dataset")

#Bivariant analysis:
#continous to continous ----> scatter plot
#continous to categorical ----> Box Plot
#exploring multiple continous columns:
cont_cols <- c("eps","watched","watching","dropped","rating","votes")
par(mfrow=c(1,1))
plot(anime_dataset[, cont_cols], col='blue')

# we will See votes vs rating
ggplot(anime_dataset,aes(y=votes,x=rating))+geom_point(shape=1,col="blue")+
  geom_smooth(method = "lm",se= F, colour="red")

#Exploring multiple categorical variables:
cat_cols<- c("mediaType","ongoing","sznOfRelease")
par(mfrow=c(2,3))
for (i in cat_cols){
  boxplot(rating~ (anime_dataset[,c(i)]), data = anime_dataset, 
          main=paste('Box plot of:',i),col=brewer.pal(8,"Paired"))
}

# Strength of Relationship between predictor and target variable
# Continuous Vs Continuous ---- Correlation test
# Continuous Vs Categorical---- ANOVA test

# Continuous Vs Continuous : Correlation analysis
# Correlation for multiple columns at once
contCOls<-  c("eps","watched","watching","dropped","rating","votes")
#we will find the correlation between these column
cor(anime_dataset[,contCOls])
# as we see there is no correlation between rating and eps
#heatmap to visulaize the correlation;
heatmap(cor(anime_dataset[,contCOls]))
# so we will drop the column eps from datasets;
anime_dataset$eps<-NULL

## Continuous Vs Categorical correlation strength: ANOVA
# Analysis of Variance(ANOVA)

# H0: Variables are NOT correlated
# Small P-Value--> Variables are correlated(H0 is rejected)
# Large P-Value--> Variables are NOT correlated (H0 is accepted)
summary(aov(anime_dataset$rating ~ anime_dataset$mediaType),data=anime_dataset)
summary(aov(anime_dataset$rating ~ anime_dataset$ongoing),data=anime_dataset)
summary(aov(anime_dataset$rating ~ anime_dataset$sznOfRelease),data=anime_dataset)

# all variables are good: (mediaType,ongoing,sznOfRelease)
#Now look again structure
str(anime_dataset)
#6.	Feature selection: done
#Finalize the set of potential predictors to be used in the linear regression algorithm

#step-07 
#Splitting the data into train & test
library(caTools)
set.seed(900)
#splitting the Train sample (70%) and test sample (30%)
split<- sample.split(anime_dataset$rating,SplitRatio = 0.7)
table(split) # it will give us frequency of True and false 

training<- subset(anime_dataset,split==T)
test<- subset(anime_dataset, split==F)

#Step-08
# Creating Predictive models on training data to check the accuracy of each algorithm
###### Linear Regression #######
model_reg<- lm(rating~.,data = training)
summary(model_reg)
#Multiple R-squared:  0.4545,	Adjusted R-squared:  0.4525
model_reg1<- lm(rating~votes+dropped+wantWatch+watching+watched
                +I(sznOfRelease=="Winter")+I(sznOfRelease=="Summer")+I(sznOfRelease=="Spring")+I(sznOfRelease=="Fall")
                +I(mediaType=="Web")+I(mediaType=="OVA")+I(mediaType=="Other")+I(mediaType=="Music Video")+I(mediaType=="Movie"),
                data = training)
summary(model_reg1) 
#Multiple R-squared:  0.4462,	Adjusted R-squared:  0.4446

#step () for best accuracy
step(model_reg)
model_reg2<- lm(formula = rating ~ mediaType + sznOfRelease + watched + watching + 
                  wantWatch + dropped + votes, data = training)
summary(model_reg2)
#Multiple R-squared:  0.4541,	Adjusted R-squared:  0.4522

#Step-09
#Checking Assumption:
#1. check for autocorrelation
# we will do durwin waston test to check autocorrelation
library(lmtest)
dwtest(model_reg2)
#DW = 0.76831 value is much much lower than 5, so we can conclude that there
#is no Autocorrelation
#2. check for multicollinearity
# for multicollinearity we will check by variance inflation factor
library(car)
vif(model_reg2)
#watched- is multicollniear because the value is 10.685282 which is greater than 5
#so, we will remove it.

model_reg3<- lm(formula = rating ~ mediaType + sznOfRelease  + watching + 
                  wantWatch + dropped + votes, data = training)
summary(model_reg3)
#Multiple R-squared:  0.4408,	Adjusted R-squared:  0.439 
# now lets check again the multicollinearity 
vif(model_reg3)
# after that there should not be any multicollinearity

#we will predict the model:
model_pred<- predict(model_reg3, newdata = test)
model_pred
# now going to see predicted price vs actual price
model_cbind<- cbind(test$rating,model_pred)
head(model_cbind)

#Checking for model accuracy
ModelError<- 100*(abs(test$rating- model_pred)/test$rating)

##we can see for each prediction what is the error I am committing
##for average accuracy: we take the average of all the errors and subtract it from 100

print(paste('### Mean Accuracy of regression model is: ', 100 - mean(ModelError)))
print(paste('### Median Accuracy of regression model is: ', 100 - median(ModelError)))
"### Mean Accuracy of regression model is:  78.59"
"### Median Accuracy of regression model is:  85.15"

###############################################################################
#Step-10
#### We will do log Transformation to improve accuracy
anime_dataset$votes<- log(anime_dataset$votes)

#lets look at the structure of anime dataset after log tranformation;
str(anime_dataset)
#Splitting the data into train & test
library(caTools)
set.seed(900)
#splitting the Train sample (70%) and test sample (30%)
split<- sample.split(anime_dataset$rating,SplitRatio = 0.7)
table(split) # it will give us frequency of True and false 

training<- subset(anime_dataset,split==T)
test<- subset(anime_dataset, split==F)


# Creating Predictive models on training data to check the accuracy of each algorithm
###### Linear Regression #######
model_reg4<- lm(rating~.,data = training)
summary(model_reg4)
#Multiple R-squared:  0.5843,	Adjusted R-squared:  0.5827
step(model_reg4)

model_reg5<- lm(formula = rating ~ mediaType + ongoing + watched + watching + 
                  wantWatch + dropped + votes, data = training)
summary(model_reg5)
#Multiple R-squared:  0.584,	Adjusted R-squared:  0.5828 
# check multicollinearity
vif(model_reg5)
# all satisfied 
#Now we will predict the model
model_pred1<- predict(model_reg5,newdata = test)
model_pred1
#check the actucal and predicted data together in dataframe
model_cbind1<- cbind(test$rating, model_pred1)
head(model_cbind1)
#Checking for model accuracy
ModelError1<- 100*(abs(test$rating- model_pred1)/test$rating)

##we can see for each prediction what is the error I am committing
##for average accuracy: we take the average of all the errors and subtract it from 100
print(paste('### Mean Accuracy of regression model is: ', 100 - mean(ModelError1)))
print(paste('### Median Accuracy of regression model is: ', 100 - median(ModelError1)))
"### Mean Accuracy of regression model is:  82.0615946346929"
"### Median Accuracy of regression model is:  88.0265566658878"

###############################################################################
# so after the log transformation we improved the accuracy of the model from 85% to 88%

################################################################################
################################################################################
################### Business recommendation ####################################
#If movies would release on mediaType(Web/Movie/).there would more chance to get more rating
#as compare to these MediaType (TV special/TV/DVD special), because most of young generation
#prefer to watch on web.



################################################################################
################ correlation test after scalling ###############################


anime_dataset$watched<- scale(anime_dataset$watched)
anime_dataset$watching<- scale(anime_dataset$watching)
anime_dataset$wantWatch<- scale(anime_dataset$wantWatch)
anime_dataset$dropped<- scale(anime_dataset$dropped)

str(anime_dataset)
colnames(anime_dataset)
anime_dataset<- anime_dataset[,c(4,5,6,7,8,9)]
#we will find the correlation between these column
cor(anime_dataset)
#heatmap to visualized the correlations
heatmap(cor(anime_dataset))





