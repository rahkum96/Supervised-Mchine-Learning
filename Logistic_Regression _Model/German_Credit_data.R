##############################################################################
############################################################################
##############################Classification case study##########################

#step1...... load the data
ger_credit<- read.csv("C:\\Users\\Rohit Kumar (Prince)\\OneDrive\\Desktop\\Ivy_Data_science\\R-\\Data_practice\\logistic_regression\\German_Credit_data.csv", na.strings = c("","","NA","NULL") )

head(ger_credit)
dim(ger_credit)
str(ger_credit)
class(ger_credit)
names(ger_credit)
summary(GermanData)

#step-2
#lets see how many feature we have convert to factor
lapply(ger_credit,function(x)length(unique(x)))

##Status_of_existing_account--->#4 unique values and also it can help to predict.

##Duration_of_Credit_month--->It will also help , to see whether the duration of month is very much shorter or longer.

##Payment_Status_of_Previous_Credit.Credit_history.--->5 , what is their status of payment can help to predict.

##Purpose_of_loan--->As here too many unique labels and also it can't help

##"Credit_Amount","Value_of_Savings_account.bonds","Years_of_Present_Employment","Percentage_of_disposable_income","Sex_._Marital_Status",                            
##"Guarantors.Debtors","Duration_in_Present_Residence","Property","Age_in_years","Concurrent_Credits","Housing",
##"No_of_Credits_at_this__Bank","Occupation","No_of_dependents","Telephone" ,"Foreign_Worker"
## As we don't have proper definition of all the variable so lets explore on the basis of statistical test

#"Creditability"---> will check the customer is trustworthiness or not #Factor#2


#Purpose_of_loan- it is not usefull for us. useless column and factor label is 10
ger_credit$Purpose_of_loan<-NULL
head(ger_credit)
str(ger_credit)


###check if all the categorical variables are factor or not
#by using loop we will convert to factor 
cols<-c("Creditability","Status_of_existing_account","Payment_Status_of_Previous_Credit.Credit_history.",
        "Value_of_Savings_account.bonds","Years_of_Present_Employment",
        "Percentage_of_disposable_income","Sex_._Marital_Status","Guarantors.Debtors",
        "Duration_in_Present_Residence","Property","Concurrent_Credits","Housing",
        "No_of_Credits_at_this__Bank","Occupation","No_of_dependents", "Telephone","Foreign_Worker")
for (i in cols){
  ger_credit[,i]<-as.factor(ger_credit[,i])
}

str(ger_credit)


#step3....... data pre-processing

#check missing values
colSums(is.na(ger_credit))
colSums(ger_credit=="")


#Step-4..........Data visualization
#Explore each "Potential" predictor for distribution and Quality

#for continuous variables we will plot it by histogram graph
#for categorical variables  we will plot it by bar graph

# Exploring MULTIPLE CONTINUOUS features
hist_con<- c("Duration_of_Credit_month","Credit_Amount","Age_in_years")

#splitting the plot window into 2 parts
par(mfrow=c(2,3))

# library to generate professional colors
library(RColorBrewer) 

# looping to create the histograms for each column
for(i in hist_con){
  hist(ger_credit[,c(i)],main=paste('Histogram of:',i),
       col = brewer.pal(8,"Paired"))
}

############################################################
# Exploring MULTIPLE CATEGORICAL features
bar_cols<- c("Creditability","Status_of_existing_account","Payment_Status_of_Previous_Credit.Credit_history.",
             "Value_of_Savings_account.bonds","Years_of_Present_Employment",
             "Percentage_of_disposable_income","Sex_._Marital_Status","Guarantors.Debtors",
             "Duration_in_Present_Residence","Property","Concurrent_Credits","Housing",
             "No_of_Credits_at_this__Bank","Occupation","No_of_dependents", "Telephone","Foreign_Worker")

#Splitting the plot window into four parts
par=(mfrow=c(3,9))


# looping to create the Bar-Plots for each column
for(i in bar_cols){
  barplot(table(ger_credit[,c(i)]),main=paste("Barplot of:",i),
                col=brewer.pal(8,"Paired"))
}

#Step-5

############################################################# 
# Statistical Relationship between target variable (Categorical) and predictors

# now we will check the relationship strength:
#contentious vs continuous-------> correlation test
#categorical vs contentious-------> ANOVA test
#categorical vs categorical-------> Chi-square test

# Continuous Vs Categorical relationship strength: ANOVA
# Analysis of Variance(ANOVA)
# H0: Variables are NOT correlated
# Small P-Value <5%--> Variables are correlated(H0 is rejected)
# Large P-Value--> Variables are NOT correlated (H0 is accepted)

summary(aov(Duration_of_Credit_month~Creditability,data = ger_credit))
summary(aov(Credit_Amount~Creditability,data = ger_credit))
summary(aov(Age_in_years~Creditability,data = ger_credit))

#All these variables are good

#### Categorical Vs Categorical relationship strength: Chi-Square test
# H0: Variables are NOT correlated
# Small P-Value--> Variables are correlated(H0 is rejected)
# Large P-Value--> Variables are NOT correlated (H0 is accepted)

##It takes crosstabulation as the input and gives you the result

chisq_cols<-c("Creditability","Status_of_existing_account","Payment_Status_of_Previous_Credit.Credit_history.",
              "Value_of_Savings_account.bonds","Years_of_Present_Employment",
              "Percentage_of_disposable_income","Sex_._Marital_Status","Guarantors.Debtors",
              "Duration_in_Present_Residence","Property","Concurrent_Credits","Housing",
              "No_of_Credits_at_this__Bank","Occupation","No_of_dependents", "Telephone","Foreign_Worker")
for(i in Chisqcols){
  CrossTabResult=table(ger_credit[,c('Creditability',i)])
  ChiResult=chisq.test(CrossTabResult)
  print(i)
  print(ChiResult)
}
#we will reject the columns
#c("Sex_._Marital_Status","Guarantors.Debtors","Occupation","Telephone","Foreign_Worker")

ger_credit[,c("Sex_._Marital_Status","Guarantors.Debtors","Occupation","Telephone","Foreign_Worker")]<- list(NULL)
str(ger_credit)
class(ger_credit)

###############################################################################
##############################split the data into training and testing########
#Step-06
#library for splitting the train and test data
library(caTools)

#it will fixed the training data
set.seed(123)

# Sampling | Splitting data into 70% for training 30% for testing
split<- sample.split(ger_credit$Creditability,SplitRatio = 0.8)
split
table(split)

training<- subset(ger_credit,split==T)
test<- subset(ger_credit,split==F)


#############################################################################################
#############################################################################################
# Creating Predictive models on training data to check the accuracy on test data
###### Logistic Regression #######

##we are predicting TV based on all other variables
##glm() is used for wide variety of modeling activities. Logistic regression
#is one of the models that you can create using glm()
##in order to tell glm() that you have to perform logistic regression,
#you have to say family= 'binomial"


lg_model<- glm(Creditability~.,data = training,family = "binomial")
summary(lg_model)

##probabilities will guide you whether to accept or reject a particular column

lg_model1<-glm(Creditability~.-Duration_of_Credit_month-Age_in_years,data = training,family = "binomial")
summary(lg_model1)
names(ger_credit)
lg_model2<- glm(Creditability~.-Duration_of_Credit_month-Years_of_Present_Employment-Property-Age_in_years-(Payment_Status_of_Previous_Credit.Credit_history.) ,data = training,family = "binomial")
summary(lg_model2)

lg_model3<- glm(Creditability~+Credit_Amount
                +I(Status_of_existing_account==2)+I(Status_of_existing_account==3)+I(Status_of_existing_account==4)
                +I(Value_of_Savings_account.bonds==2)+I(Value_of_Savings_account.bonds==3)+I(Value_of_Savings_account.bonds==4)+I(Value_of_Savings_account.bonds==5)
                +I(Percentage_of_disposable_income==2)+I(Percentage_of_disposable_income==3)+I(Percentage_of_disposable_income==4)
                +I(Duration_in_Present_Residence==2)+I(Duration_in_Present_Residence==3)+I(Duration_in_Present_Residence==4)
                +I(Concurrent_Credits==2)+I(Concurrent_Credits==3)
                +I(Housing==2)+I(Housing==2)
                +I(No_of_Credits_at_this__Bank==2)+I(No_of_Credits_at_this__Bank==3)+I(No_of_Credits_at_this__Bank==4)
                +I(No_of_dependents==2),
                data = training,family = "binomial")
summary(lg_model3)
#This indicate that one unit increase in the credit  will decrease
#the creditability by a factor of exp(-1.848)

## Similarly give observations for other continuous column


#if you belong to status of existing account 2 compared to status of existing account 1, you are more  likely to give creditability
#if you belong to status of existing account 2 compared to tatus of existing account 2, then the Crediatibility increases
#by 2.802 %

## Similarly give observations for other categorical column 

# Checking Accuracy of model on Testing data
pred<- predict(model2,newdata = test,type = 'response')
pred

##considering a threshold of 0.50
pred_thres_50<-ifelse(pred>0.5,1,0)
pred_thres_50
# now we have create confusion matrix table
cm<-table(test$Creditability,pred_thres_50) 
cm

# Creating the Confusion Matrix to calculate overall accuracy, precision and recall on TESTING data
##install.packages('caret', dependencies = TRUE)
library(caret)

confusionMatrix(cm)

### Overall Accuracy of Logistic Reg Model is:  76 %
### You can increase the accuracy by changing the threshold value.
#############################################################################################

#now we will change the thershold value to increase the accuracy
pred_thres_60<-ifelse(pred>0.6,1,0) #71.1%
cm1<-table(test$Creditability,pred_thres_60)
confusionMatrix(cm1)

pred_thres_40<-ifelse(pred>0.4,1,0) #73.1%
cm2<-table(test$Creditability,pred_thres_40)
confusionMatrix(cm2)

## so the threshold value at 0.5 will give us better accuracy as compare to other threshold values.




