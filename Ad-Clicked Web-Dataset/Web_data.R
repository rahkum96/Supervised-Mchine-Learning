###############################################################################
################### Web_dataset--> Logistic Regression ########################
#Step-01
#problem statement: The goal of the case study is to Predict who is likely going 
#to click on the Advertisement so it can contribute to the more revenue generation 
#to the organization.

#Step-02
#Import the dataset 
web_dataset<- read.csv("C:\\Users\\Rohit Kumar (Prince)\\OneDrive\\Desktop\\Ivy_Data_science\\R-\\HW\\Web_dataset\\Web_data.csv", na.strings = c(""," ","NA","NULL") )
#look first 6 rows of datset
head(web_dataset)
#lets check the class of dataset
class(web_dataset)
#look at the structure of dataset
str(web_dataset)  
dim(web_dataset)#6657 obs. of  14 variables:
#lets look at summary of dataset
summary(web_dataset)
#An interesting fact from the summary table is that the smallest area income is 
#13,996and the highest is 79,485. 
#This means that site visitors are people belonging to different social classes.

#It can also be concluded that we are analyzing a popular website 
#since users spend between 32 and 91 minutes on the website in one session. These are really big numbers!

#Furthermore, the average age of a visitor is 36 years. 
#We see that the youngest user has 19 and the oldest is 61 years old. 
#We can conclude that the site is targeting adult users. 

################################################################################
#Now lets a look which variables we have to move to factors
lapply(web_dataset,function(x)length(unique(x)))

# VistID: There are too many unique elements within these column and 
#it is generally difficult to perform a prediction without the existence of a data pattern. 
#Because of that, it will be omitted from further analysis. 

# Country_Name: We have already seen, there are 237 different unique countries 
#in our dataset and no single country is too dominant. 
#A large number of unique elements will not allow a machine learning model to 
#establish easily valuable relationships. For that reason, this variable will be excluded too.

#Year: it is also not going to help us in prediction because it has only one year 2020 repeating all the time.

#here we are going to remove the useless column 
useless_col <- c("VistID","Country_Name","Year")
web_dataset[,useless_col]=NULL
#Now lets look at again structure of dataset
str(web_dataset)
# Now we will move some of varaibles to factors
factor_cols<- c("Ad_Topic","City_code","Male","Time_Period","Weekday","Month","Clicked")
for(i in factor_cols){
  web_dataset[,i]=as.factor(web_dataset[,i])
}
#Now str of dataset
str(web_dataset)


################################################################################
#step-03
#data pre-processing
#a)checking for missing values 
colSums(is.na(web_dataset)) #We did not find any numeric missing values
colSums(web_dataset=="") # We did not find any categorical missing values
#b) checking for outliers by using boxplot
#in column "Time_Spent"
boxplot(web_dataset$Time_Spent) #We didnt find 
#Now checking outliers in in column "Age"
boxplot(web_dataset$Age) # we did'nt find 
boxplot(web_dataset$Avg_Income) # we will not considered
boxplot(web_dataset$Time_Period) # we did'nt find 

#C. endocing concept - We have already done it
#d. Feature scalling - we have to do it becasue "Avg_income" is really huge number as 
#compare to other variables, We will do that before going to make model

################################################################################
#Step-04
################# Univariate and Bivariate Analysis ############################

#Univariate Analysis;
#for continuous variables we will plot it by histogram graph
#for categorical variables  we will plot it by bar graph

## we will install the packages 
library(RColorBrewer)
library(ggplot2)
# Exploring MULTIPLE CONTINUOUS feature
Hist_cols<- c("Time_Spent","Age","Avg_Income","Internet_Usage")
#splitting the plot window into 2 parts
par(mfrow=c(2,3))

for(i in Hist_cols){
  hist(web_dataset[,c(i)],main = paste("Histogram of:",i),
       col = brewer.pal(8,"Paired"))
}
#To set plot size

graphics.off() 
par("mar") 
par(mar=c(1,1,1,1))

# Exploring MULTIPLE CATEGORICAL features
bar_cols<- c("Ad_Topic","City_code","Male","Time_Period","Weekday","Month","Clicked")
#Splitting the plot window into 2 parts
par=(mfrow=c(2,4))
for (i in bar_cols){
  barplot(table(web_dataset[,c(i)]),main = paste("Barplot of:",i),
          col = brewer.pal(8,"Paired"))
}
#Bivariant analysis:
#continous to continous ----> scatter plot
#continous to categorical ----> Box Plot
#categorical to categorical---> group bar plot
#exploring multiple continous columns:

# Categorical Vs Continuous Visual analysis: Boxplot
cont_cols<- c("Time_Spent","Age","Avg_Income","Internet_Usage")
par(mfrow=c(1,4))
for (i in cont_cols){
  boxplot((web_dataset[,c(i)]~Clicked), data = web_dataset, 
          main=paste('Box plot of:',i),col=brewer.pal(8,"Paired"))
}

# Categorical Vs Categorical Visual analysis: Grouped Bar chart
#cat_cols<- c("Ad_Topic","City_code","Male","Time_Period","Weekday","Month","Clicked")
library(ggplot2)
#0: Not clicked
#1: clicked 
ggplot(web_dataset,aes(x=Month,fill=Clicked))+geom_bar()
#In Month of July and March clicked are less as compare to other months
ggplot(web_dataset,aes(x=Weekday,fill=Clicked))+geom_bar()
#almost all these days clicked are same on Wednesday slight less
ggplot(web_dataset,aes(x=Time_Period,fill=Clicked))+geom_bar()
#in the evening clicked are bit more as compare to other time 
ggplot(web_dataset,aes(x=City_code,fill=Clicked))+geom_bar()
#in the city 1 has max no of clicked as compare to other city
ggplot(web_dataset,aes(x=Male,fill=Clicked))+geom_bar()
#female has more clicked on Ad as compare to male 

#Lets check the percentage clicked by male and female 
summary(web_dataset$Male)/nrow(web_dataset)
#Finally, if we are wondering whether the site is visited more by men or women, 
#we can see that the situation is almost equal (52% in favor of women).

# Statistical Relationship between target variable (Categorical) and predictors

# Categorical Vs Continuous --- ANOVA
# Categorical Vs Categorical -- Chi-square test

# Continuous Vs Categorical relationship strength: ANOVA
# Analysis of Variance(ANOVA)
# H0: Variables are NOT correlated
# Small P-Value <5%--> Variables are correlated(H0 is rejected)
# Large P-Value--> Variables are NOT correlated (H0 is accepted)
#cont_cols<- c("Time_Spent","Age","Avg_Income","Internet_Usage")
summary(aov(Time_Spent~Clicked, data = web_dataset))
summary(aov(Age~Clicked, data = web_dataset))
summary(aov(Avg_Income~Clicked, data = web_dataset))
summary(aov(Internet_Usage~Clicked, data = web_dataset))

#Hence we can say that all are good variables, because p-value is less than 0.05

#### Categorical Vs Categorical relationship strength: Chi-Square test
# H0: Variables are NOT correlated
# Small P-Value--> Variables are correlated(H0 is rejected)
# Large P-Value--> Variables are NOT correlated (H0 is accepted)


##It takes crosstabulation as the input and gives you the result
chi_cols<- c("Ad_Topic","City_code","Male","Time_Period","Weekday","Month")
for(i in chi_cols){
  CrossTabResult=table(web_dataset[,c('Clicked',i)])
  ChiResult=chisq.test(CrossTabResult)
  print(i)
  print(ChiResult)
}
#weekdays:p-value = 0.7226
#"Month":p-value = 0.4229
#we will remove these column from dataset
web_dataset[,c("Weekday","Month")]<- NULL
#let see the str of dataset
str(web_dataset)
# Here we will do feature scalling because the "Avg_Income" variable are much much
#greater than other variables 
set.seed(123)
web_dataset$Avg_Income<- scale(web_dataset$Avg_Income)
web_dataset$Time_Spent<-scale(web_dataset$Time_Spent)
web_dataset$Internet_Usage<-scale(web_dataset$Internet_Usage)

################################################################################
#05.	Feature selection: done
#Finalize the set of potential predictors to be used in the linear regression algorithm

#checking the data is balance or not
table(web_dataset$Clicked)/nrow(web_dataset)
#here our data is balanced around 54% Not clicked and 45% clicked 

#first we will check the structure of dataset
str(web_dataset)
web_dataset$Clicked<- ifelse(web_dataset$Clicked==1,0,1)
#step-06
#Splitting the data into train & test
library(caTools)
set.seed(123)
#splitting the Train sample (70%) and test sample (30%)
split<- sample.split(web_dataset$Clicked,SplitRatio = 0.7)
table(split) # it will give us frequency of True and false 

training<- subset(web_dataset,split==T)
test<- subset(web_dataset, split==F)

# step-07
# we will build logistic regression model with the set of potential predictors 
#identified from Exploratory data analysis and obtain the significant predictors

logit<- glm(Clicked~., data = training,family = "binomial")
summary(logit)

#we will use step () for better AIC value
step(logit)

logit1<- glm(formula = Clicked ~ Time_Spent + Age + Avg_Income + Internet_Usage + 
               City_code + Time_Period, family = "binomial", data = training)
summary(logit1)
#Deviance is a measure of goodness of fit of a generalized linear model.
#Or rather, it's a measure of badness of fit: higher numbers indicate worse fit.
#The null deviance: shows how well the response variable is predicted by a model 

#residual deviance has to be lesser than null deviance to have a good model

##Unlike R-squared- this AIC value is relative
#as you run different models you see how the AIC value is changing
#lower it is, better is the model

#step-08
#	Multicollinearity check in the final model by variance inflation factor
library(car)
vif(logit1)
# all the predictors are independent from each other, so now we can predict the model

#step-09
#9.	Predictions: Using the obtained model, generate the prediction probabilities on the test data. 
#Considering the threshold, obtain the predictions on the test data set

pred<- predict(logit1,newdata = test)
pred
#considering the thresholds value 0.50
pred_50<- ifelse(pred>0.5,1,0)

#now we have to create confusion matrix table
cm<- table(test$Clicked,pred_50)
cm
# now we will calculate accuracy, precision, sensitivity and specificity
library(caret)
confusionMatrix(cm)
# our model is 91% accuracy based on 95% of confidence interval
#accuracy lies between (0.8991, 0.9244) 
#Sensitivity/Recall : 0.9000          
#Specificity : 0.9229
#Pos Pred Value/precision : 0.9089
#we will calculate F1-score= 2*(recall* precision)/recall+precision 
f1<- 2*(0.9000* 0.9089)/(0.9000+0.9089)
f1 #0.9044281

################################################################################
#It can be concluded that the variable 'Age' has a normal distribution of data.
# we can conclude that younger users spend more time on the site. 
#This implies that users of the age between 20 and 40 years can be the main target
#group for the marketing campaign. 
#Hypothetically, if we have a product intended for middle-aged people, 
#this is the right site for advertising. 
#Conversely, if we have a product intended for people over the age of 60, 
#it would be a mistake to advertise on this site.