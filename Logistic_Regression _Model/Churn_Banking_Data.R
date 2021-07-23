#########################################################################
#################### classification case study###########################

# In case of classification problem- Target variable is always categorical

#problem statements: the business objective is to summarize variables that contribute in the
#prediction of profitable customers (denoted by 1 of Churn variable), such that newly
#reformed customer policies can be directed to valuable/profitable customers of the 
#bank. 

# load the data
bank_data<- read.csv("C:\\Users\\Rohit Kumar (Prince)\\OneDrive\\Desktop\\Ivy_Data_science\\R-\\HW\\Logistic regression\\Churn_Banking_Data.csv",na.strings = c("","","NA","NULL"), stringsAsFactors = T)
View(bank_data)
head(bank_data)

#2. we will check the dimension and see the data
dim(bank_data)
summary(bank_data)

#3. See the overall structure of data 
str(bank_data)
#now check which variables have to move to factor
lapply(bank_data,function(x)length(unique(x)))

# so the churn - 2, Num_loans- 15, Num_dependents- 11,Num_Savings_Acccts-09. 
#these are to move to factors

str(bank_data)

# we use for loop to move multiple variables to factor
factor_cols<- c("Churn","Num_loans","Num_dependents","Num_Savings_Acccts")
for (cols in factor_cols){
  bank_data[,(cols)]<- as.factor(bank_data[,(cols)])
}
str(bank_data) # to see again structure of data after move to factor

#4. Data Visualization
######## for Uni-variant############### 
#continuous vs continuous - Histogram
# contentious vs categorical - Bar plot

##Exploring multiple categorical variables, Bar plot for each columns 
library(RColorBrewer)
cols_bar<-c("Churn","Num_loans","Num_dependents","Num_Savings_Acccts")
par(mfrow=c(2,3))
# for loop function 
for (catCol in cols_bar){
  barplot(table(bank_data[,c(catCol)]), main=paste('Barplot of:', catCol), 
          col=brewer.pal(9,"Paired"))
}

##multiple contentious variables
colnames(bank_data) # to check the column names
cols_hist<- c("Utilization.ratio","Age","MonthlyIncome")
par(mfrow=c(2,3))
library(RColorBrewer)

#we used for loop to see multiple columns histogram 
for (conCol in cols_hist){
  hist(bank_data[,c(conCol)], main=paste('Histogram of:', conCol), 
       col=brewer.pal(8,"Paired"))
}

################bi-variant analysis##########################
# we will do analysis of two variables, target and predictors variables 
#Continuous Vs Continuous --- Scatter Plot
#Continuous Vs Categorical --- Box Plot
#categorical vs Categorical--- group bar chart

####################################################
# categorical vs continuous analysis- Box plot
#("Utilization.ratio","Age","MonthlyIncome") - continuous variables,
# "Churn" - categorical

library(ggplot2)
#Utilization.ratio vs Churn box plot;
box_plot <- ggplot(bank_data, aes(x = Utilization.ratio, y = Churn ))
# Add the geometric object box plot
box_plot +
  geom_boxplot()+ coord_flip()

#Age vs Churn - box plot
library(RColorBrewer)

boxplot(Churn~Age, data = bank_data,col=brewer.pal(8,"Paired"))

box_plot <- ggplot(bank_data, aes(x = Age, y = Churn ))
box_plot +
  geom_boxplot(outlier.colour = "red",
               outlier.shape = 2,
               outlier.size = 3)+ coord_flip()

#MonthlyIncome vs Churn 
box_plot <- ggplot(bank_data, aes(x = MonthlyIncome, y = Churn ))
box_plot +
  geom_boxplot(outlier.colour = "red",
               outlier.shape = 2,
               outlier.size = 3)+ coord_flip()

#############################################################################
## categorical vs categorical- group bar plot
#Churn to ("Num_loans","Num_dependents","Num_Savings_Acccts")
#how many times person taken loans
#how many Number of dependents the person has upon himself/herself.
#how many Number of savings account the customer has with the bank.
#categorical_<-c("Num_loans","Num_dependents","Num_Savings_Acccts")

#Num_loans vs Churn 
ggplot(bank_data,aes(x=Num_loans, fill=Churn))+ geom_bar()+
  labs(x="num of loans",
       y= "Churn",
       title ="Chrun vs num of loan taken from bank")

#Num_dependents vs Chrun
ggplot(bank_data,aes(x=Num_dependents, fill=Churn))+ geom_bar()+
  labs(x="Num_dependents",
       y= "Churn",
       title ="Chrun vs Num_dependents")

#Num_Savings_Acccts va Churn
ggplot(bank_data,aes(x=Num_Savings_Acccts, fill=Churn))+ geom_bar()+
  labs(x="Num_Savings_Acccts",
       y= "Churn",
       title ="Chrun vs Num_Savings_Acccts")

#5. data pre-processing
#checking missing values
colSums(is.na(bank_data))
# we didn't find any missing data

#In classification problem outliers does not play a role
##################################################################################
#Now checking the strength of relation between target variables and predictor variables

# continuous vs continuous--- correlation  test
# categorical vs continuous--- ANOVA test
# Categorical vs categorical --- chi- square test

##########################
# Categorical Vs Continuous  correlation strength: ANOVA
# Analysis of Variance(ANOVA)
#H0: Null hypothesis
#p-low ------ (Null go) variables are correlated  (we reject H0)
#p-high ----- variables are not correlated (we do not reject H0)

#predictor variables:c("Utilization.ratio","Age","MonthlyIncome")- continuous
#target_variable :Churn - categorical
#summary(aov(predictor_variable~ target_variable, data = bank_data))
cols_ANOVA <- c("Utilization.ratio","Age","MonthlyIncome")
for (cols in cols_ANOVA){
  test_summary=summary(aov(bank_data[,c(cols)]~Churn , data = bank_data))
  print(paste("The Anova test with",cols))
  print(test_summary)
}
#"Utilization.ratio","Age","MonthlyIncome"- is good variables (p-value is low)

###Categorical Vs Categorical relationship strength: Chi-Square test
#("Num_loans","Num_dependents","Num_Savings_Acccts")- categorical,
#Churn- categorical

#crosstabulation as the input and gives you the result
#cols_chi <- c("Num_loans","Num_dependents","Num_Savings_Acccts")

#Num_loans vs Churn---chi-square Test
CrossTabResult=table(bank_data[,c('Churn','Num_loans')])
CrossTabResult
barplot(CrossTabResult, beside=T, col=c('Red','Green'))

#Num_dependents vs Churn---chi-square Test
CrossTabResult=table(bank_data[,c('Churn','Num_dependents')])
CrossTabResult
barplot(CrossTabResult, beside=T, col=c('Red','Green'))

#Num_Savings_Acccts vs Churn ---chi-square test
CrossTabResult=table(bank_data[,c('Churn','Num_Savings_Acccts')])
CrossTabResult
barplot(CrossTabResult, beside=T, col=c('Red','Green'))

##########7. Split the data into training and testing##################
library(caTools)
set.seed(123)
split<- sample.split(bank_data$Churn,SplitRatio = 0.80)

table(split)

training<- subset(bank_data,split=T)
test<- subset(bank_data,split= F)

#################################################################################
#############################################################################
#############Logistic Regression ############################

#we are predicting Churn based on all other variables
##glm() is used for wide variety of modeling activities. Logistic regression
#you have to say family= 'binomial" because its classification problem
###now we will create the model for logistic regression
colnames(bank_data)

classifier<- glm(Churn~., data = training, family = 'binomial')
summary(classifier)
classifier1<- glm(Churn~.-Num_dependents, data = training, family = 'binomial')
summary(classifier1)
classifier2<- glm(Churn~.-Num_dependents-Num_Savings_Acccts, data = training, family = 'binomial')
summary(classifier2)

#Null deviance---73616: system will generate error without taking predictor variables
#Residual deviance--- 57744: error with predictor variables
#AIC---57782: adjusted r-square in logistic regression

#residual deviance has to be lesser than null deviance to have a good model--satisfied

#if you change the model the AIC values will also change,  
#lower the AIC value  better the model.

#we have to predict the model by using predict()
# we use type="response", we will use classifier2 to the predict
pred<- predict(classifier2,newdata = test,type = "response")
pred
# we are checking the threshold value at 0.50
thres_50<- ifelse(pred>0.50,1,0)
str(bank_data)
#thres_50_cbind <- cbind(test,thres_50)
#thres_50_cbind 
#head(thres_50_cbind)
#str(thres_50_cbind)
#thres_50_cbind$Churn<- as.numeric(thres_50_cbind$Churn)
#thres_50_cbind$Churn<- ifelse(thres_50_cbind$Churn==2,1,0)

# next step is find the confusion matrix
#for confusion matrix we need actual data and predicted data 
#we use table() for confusion matrix
cm<- table(test$Churn,thres_50)
cm

#Now we have find all the parameter in confusion matrix
#accuracy --- (TP+TN)/total
#sensitivity/recall---- TP/(TP+FN)
#specificity ----- TN/(TN+FP)
#precision/POSITIVE PREDICTED VALUE------ TP/(TP+FP)
#false negative value------ FN/FN+TN
#false positive value------- FP/TP+FP
#F1-MEASURE--------- (2*RECALL*PRECISION)/RECALL+PRECISION

library(caret)
library(e1071)
confusionMatrix(cm)
#Accuracy : 0.9363
#Sensitivity : 0.93831        
#Specificity : 0.68999
#Pos Pred Value/precision : 0.99728        
#Neg Pred Value : 0.08458  

# we will change the threshold value to get more accuracy
# we will use MLE (maximum likelyhood estimation)
# here we increase the thresehold value whic is 0.6
thres_60<- ifelse(pred>0.6,1,0)
cm1<- table(test$Churn,thres_60)
confusionMatrix(cm1)

#getting accuracy 0.935  

# here we increase the thresehold value whic is 0.7
thres_70<- ifelse(pred>0.7,1,0)
cm2<- table(test$Churn,thres_70)
confusionMatrix(cm2)
#getting accuracy 0.9339

# now we will check accuracy at threshhold value 0.40
thres_40<- ifelse(pred>0.4,1,0)
cm3<- table(test$Churn,thres_40)
confusionMatrix(cm3)
#Accuracy : 0.9357 

#by using MLE we can say that threshold value at  0.50 will give better accuracy
#which is = 93.63%

scoreF1 <- (2*0.93831*0.99728)/(0.93831+0.99728)
scoreF1 #0.9668967 


##now we would do AUC(area under the curve) and ROC (receiver oprating curve)
#for the best fit sigmoid curve 

# we will use prediction() for the prediction 
#and we will use performance() on prediction

library(ROCR)
rocprediction<- as.numeric(prediction(test$Churn,thres_50))
rocperformance<- performance(rocprediction,'tpr','tnr')

plot(rocperformance,col='red',print.cutoffs.at=seq(0.1,by=0.1))
