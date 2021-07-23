
################################################################################
################################################################################
######################### Decision Tree ########################################


churn_data <- read.csv("C:\\Users\\Rohit Kumar (Prince)\\OneDrive\\Desktop\\Ivy_Data_science\\R-\\Data_practice\\Decision_tree\\churn.csv", na.strings = c("","","NA","NULL"))
head(churn_data)
class(churn_data)
str(churn_data)
colnames(churn_data)
summary(churn_data)

###We have removed the useless column;
colnames(churn_data)
churn_data<- churn_data[,c(3,6,19,20,21)]
# we will takes these columns as a predictor
head(churn_data)
str(churn_data)


#check for the missing values 
colSums(is.na(churn_data))
#No missing vales found

#splitting the sample into test and training data

#library for split  test and train data
library(caTools)
set.seed(101)
#sample split- taking Training 80% and test 20%
split<- sample.split(churn_data$Churn,SplitRatio = 0.80)
table(split) # it will give how many data in training and test


training<- subset(churn_data,split==T)
test<- subset(churn_data,split==F)

###############################################################################
###############################################################################

#The beauty of decision tree is that if we have 20 variables it will takes only 
#those variables which which is good predictor for targets variables

#library for decision tree
library(rpart)
library(rpart.plot)

###Building Decision tree model by using 'rpart'
dtree<-rpart(Churn~.,data = training)

#plotting the decision tree
plot(dtree)
text(dtree)
rpart.plot(dtree)

#Library for fancy plot tree
library(rattle)

fancyRpartPlot(dtree)

#Now we are going to predict our model
dtree_pred<- predict(dtree,newdata = test,type = 'class')
head(dtree_pred)

head(dtree_pred)


#now we have to make confusion matrix

cm<-table(test$Churn,dtree_pred)

length(test$Churn)
length(dtree_pred)
cm

# to find accuracy, sensitivity/recall, precision we have install package "caret"
library(caret)

confusionMatrix(cm)

#Accuracy : 0.7112 






