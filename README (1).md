
# Predictive Analysis of Ad-click Website data

Ranging from high-profile platforms to local listings, online directories cover a range of audiences as well as additional details about your business or organization. This helps promote your website by boosting its search engine ranking, increasing the chances that they’ll get paid by Google by drawing traffic to google ad on the website. The goal of the case study is to Predict who is likely going to click on the Advertisement so it can contribute to the more revenue generation to the organization.



## Objective

 The goal of the case study is to Predict who is likely going to click on the Advertisement so it can contribute to the more revenue generation to the organization
##  Approach
1. Identify the Problem Statement - what are you trying to solve?
2. Import the dataset and identify the Target variable in the data.
   Identifying the type of variables: Identifying the nature of different columns (Continuous / Categorical ), removing garbage columns (if any) and conversion of categorical variables to factors if they are not in factors.
3. Data pre-processing: Checking and treating the missing values with appropriate measures. Checking the presence of outliers by creating boxplots and treating the outliers (if any).
4.	Univariate and Bivariate Analysis: Explore each "Potential" predictor for distribution (visual analysis –histogram/bar plot) and also explore their relationship with the target variable (visual analysis –boxplot/grouped bar chart and statistical tests – ANOVA/Chi-square).
5.	Feature selection: Finalize the set of potential predictors to be used in the logistic regression algorithm.
6.	Splitting the data into train & test: Divide the data into two parts: Train sample (70%) and test sample (30%). The machine learning algorithm will be applied on the Train set and the model will be validated on the test set.
7.	Model Building: Form the logistic regression model with the set of potential predictors identified from Exploratory data analysis and obtain the significant predictors.
8.	Multicollinearity check: Check the presence of Multicollinearity in your final model and remove the variables with high multicollinearity one by one from your final model to arrive at the model which will be used to generate predictions on the test data.
9.	Predictions: Using the obtained model, generate the prediction probabilities on the test data. Considering the threshold, obtain the predictions on the test data set.
10.	Accuracy measures: Obtain the confusion matrix. Obtain the “overall” value of accuracy, Precision, Recall/Sensitivity, Specificity, Balanced accuracy, F1-score.



  
## Step by Step Solution explanation
### Summary of dataset:
- 1: clicked 
- 0: not clicked 


- An interesting fact from the summary table is that the smallest area income is 13,996 and the highest is 79,485. This means that site visitors are people belonging to different social classes.
- Since users spend between 32 and 91 minutes on the website in one session. These are big numbers!
- It can also be concluded that we are analysing a popular website.
- Furthermore, the average age of a visitor is 36 years. We see that the youngest user has 19 and the oldest is 61 years old. We can conclude that the site is targeting adult users.
  Removing the Garbage variables:

- VistID: There are too many unique elements within these columns, and it is generally difficult to perform a prediction without the existence of a data pattern. Because of that, it will be omitted from further analysis. 
- Country_Name: We have already seen, there are 237 different unique countries in our dataset and no single country is too dominant. Many unique elements will not allow a machine learning model to establish easily valuable relationships. For that reason, this variable will be excluded too.
- Year: it is also not going to help us in prediction because it has only one-year 2020 repeating all the time.

### Data pre-processing:
1.	Checking the missing values: We didn’t find any missing values in this dataset
2.	Checking the outliers: We haven’t found outliers as well
3.	Encoding concept: We had moved the categorical variables into factor which has not that much unique values. 
    (“Ad_Topic","City_code","Male","Time_Period","Weekday","Month","Clicked")
4.	Feature scaling: We have done feature scaling because the Avg_Income column is really huge number as compared to other columns in dataset 


### Univariate and Bivariate analysis 
#### Univariate analysis: 
- for continuous variables we will plot it by histogram graph
- for categorical variables we will plot it by bar graph

#### Bivariate analysis:
- continuous variables to continuous variables ----> scatter plot
- continuous variables to categorical variables ----> Box Plot
- categorical variables to categorical variables ---> group bar plot


- In Month of July and March clicked are less as compared to other months.
- Almost all these days clicked are same on Wednesday slight less.
- In the evening clicked are bit more as compared to other time.
- In the city 1 has max no of clicked as compared to another city.
- Female has more clicked on Ad as compared to male Finally, if we are wondering whether the site is visited more by men or women, we can see that the situation is almost equal (52% in favour of women).

### Statistical Relationship between target variable (Categorical) and predictors
#### Continuous Vs Categorical relationship strength: Analysis of Variance (ANOVA)
- H0: Variables are NOT correlated
- Small P-Value <5%--> Variables are correlated (H0 is rejected)
- Large P-Value--> Variables are NOT correlated (H0 is accepted)
  All variables are good for prediction 
#### Categorical variables Vs Categorical variables -- Chi-square test
- Column weekdays: p-value = 0.7226 and Column Month: p-value = 0.4229, We will not be considering these two variables in further analysis because the p- value is greater than 0.05


### Build the Logistic model:
- Installed packages (CaTools) and splitting the Train sample (70%) and test sample (30%)
-	glm() is used for wide variety of modelling activities. Logistic regression is one of the models that you can create using glm (). In order to tell glm() that you have to perform logistic regression, you have to say family= 'binomial"
-	We used step () to get better AIC value and for better model
-	We haven’t found the multicollinearity in these dataset
-	Then last step is summary of the final model 
#### Some fact about good model:
-	Deviance is a measure of goodness of fit of a generalized linear model.
-	residual deviance must be lesser than null deviance to have a good model.
-	Unlike R-squared- this AIC value is relative as you run different models you see how the AIC value is changing lower it is, better is the model.


### Prediction of the model
-	Using the obtained model, generate the prediction probabilities on the test data. Considering the threshold, obtain the predictions on the test data set.
-	considering the thresholds value 0.50
-	our model is 91% accuracy based on 95% of confidence interval accuracy lies between (0.8991, 0.9244) 
-	Sensitivity/Recall: 0.9000          
-	Specificity: 0.9229
-	Pos Pred Value/precision: 0.9089
-	we will calculate F1-score= 2*(recall* precision)/recall + precision 
-	f1<- 2*(0.9000* 0.9089)/ (0.9000+0.9089)
-	f1 =0.9044281

### Business Recommendation:
-	It can be determined that the data for the variable 'Age' follows a normal distribution. Younger visitors spend more time on the site; thus, we can deduce that they spend more time there. As a result, people between the ages of 20 and 40 might be the primary target group for the marketing effort.
-	In theory, if we have a product aimed at middle-aged people, here is the best place to advertise it.
-	In contrast, advertising on this site for a product aimed at persons over the age of 60 would be a mistake.
 

## Lessons Learned
I learned how to  build a machine learning classification model and understand the concept of confusion matrix during working on this project.



  