<div align="center" id="user-content-toc">
  <ul align="center" style="list-style: none;">
    <summary>
      <h1>The U.S. Census</h1>
    </summary>
  </ul>
</div>

 <h3> <p align="center">  A socioeconomic look at factors indicative of wealth  </p> </h3> <br>


<p align="center"> 
	<img width="328" height="496" src= https://www.dropbox.com/scl/fi/8fi5v7e6hwaqk33p14vie/Uncle-Sam-Cover-Photo.png?rlkey=99r4vr7a7427c65xiujhp1dgt&st=l9mlo2uc&raw=1>
</p>

_<sub> 
	<p align="center">  "Any society, any nation, is judged on the basis of how it treats its weakest members -- the last, the least, the littlest."  </p>
	<p align="center"> – Cardinal Roger Mahoney, 1998, Creating a Culture of Life </p> 
</sub>_

<br>
<br>
<br>
<br>

<p align="center"> 
	A group effort by Tommy Baw, John Benischeck, Xiaomeng Blair Chen, Shachi Parikh, Xiaoqin Helen Yi
</p>

<br>
<br>

# Table of Contents
- Abstract
- Introduction
- The Data Collection process
- The Data Cleaning process
- Data Exploration
- Predictive Modeling
- GlmNet Regression
- Logistic Regression
- Logistic Regression
- Conclusion and Remarks
- Bibliography and References
- Appendix

<br>

# Abstract

The purpose of this project is to identify key social/economic factors that are statistically proven to have strong influence on an individual’s level of income. The task is to build predictive models which determine whether or not a person makes more than $50,000 per year. While the predictive algorithm will be the main focus of the work, we will also use data visualization and correlation analysis to take a look at other potential correlations, such as ethnicity to education levels, and gender to income, to extract further information beyond the predictive models.

<br>

# Introduction

What is the American Dream? How do I achieve it? For many, that answer, and the path to it, will vary. Inevitably, those dreams will require money to pursue and maintain. News and media outlets regularly remind us that the paths for many Americans are impeded, and even blocked, due to a host of reasons. How can these roadblocks be overcome, and even removed, for future dream-seekers?

 Once per decade, the United States government collects a wealth of information from and about its citizens. To the government, lobbyists, special interest and advocacy groups, this information is a goldmine; it is a reflection on the successes and, more importantly, the failures of the past decade’s governance and social policy on the population. 

Many questions can be answered with this trove of data. The aim of this paper, however, is to explore commonly cited reasons for income inequality in the United States, and test their validity.

<br>

# Data Collection

The dataset used in this project was pulled from the UCI Machine Learning Repository<sup>1</sup>, which further cites: “_Extraction was done by Barry Becker from the 1994 Census database. A set of reasonably clean records was extracted using the following conditions: ((AAGE>16) && (AGI>100) && (AFNLWGT>1)&& (HRSWK>0))_” <sub>(University of California Irvine, 1994)</sub>. We concatenated their test and train sets, for a total of 48,842 observations and 15 attributes. In the modeling process, the variable “salary” is treated as the response, with string values of either “over 50k” or “below 50k”, indicating personal level of wealth. 

<br>
<sup>1 </sup> <sub>  The dataset comes from USI Machine Learning website http://archive.ics.uci.edu/ml/datasets/Census+Income, which was extracted from the Census Bureau database found at http://www.census.gov/ftp/pub/DES/www/welcome.html. </sub>

<br>
<br>

# Data Cleaning

Because the response variable, along with 8 predictor variables, are categorical, dummy variables were created in order to perform predictive algorithms and modeling. For the dependent variable “salary”, the dummy labels were assigned as follows: 1 for observations of earning “over $50k” per year and 0 for earning “below $50k” per year. Similarly, the same was done with the independent variables. For example, “work class” was expanded to 9 dummy, binary variables, “education” to 17 variables, “marital status” to 7 variables, and so on. This expanded our dataset to 109 predictors, and 1 response variable, ready to enter the models.

<br>

<p align="center"> 
	<img width="690" height="475" src= https://www.dropbox.com/scl/fi/l4vdb2m94al4qnf25mpr0/Data-Cleaning-1.png?rlkey=relqxshprksej86p8s7292p8q&st=edkg4kst&raw=1>
</p>

_<sub> 
	<p align="center"> The sub-categories of each categorical variable. </p>
</sub>_

<br>

Because of the categorical nature of the data, outlier detection was not a concern and, in the data exploration, we found that the sample was generally representative of the population. Additionally, it is worth noting that we observed missing values in the original dataset, and replaced them with “unknown” values. All of the missing data points were categorical and we believed that it would be more appropriate to treat “unknown” as a single dummy variable, rather than deleting an entire instance, when other information in that observation was provided. 

<br>

# Data Exploration

As laid forth above, we sought to use our data to find if certain socioeconomic and demographic factors could predict whether or not an individual is wealthy (defined as making more than $50,000 per year). We looked for early indications through visualization of the data of what a regression model might include as important factors of wealth. Additionally, we used visualization to check for anomalies in the data. There were, intuitively, three factors which we felt would be major contributors to wealth: Education, Sex (gender), and Race. Good education, as the trope and mantra goes, is the key to a good job, which implies wealth. Sex and Race are frequently touted as reasons for income inequality as well, and we wished to test these notions. 


First, we wanted to know if our sample was representative of the population, and Race is perhaps one of the easiest ways to measure this. Per the below, “White” is nearly the entire sample population of our dataset. However, these results are generally consistent with the 1990 Census (Appendix A.2). Dissimilar from the percentages in Appendix A.2, the UCI dataset does not include the Race category “Hispanic”. UCI did not provide a reason for dropping this observation. However, and while this cannot be confirmed, it appears that the percentage overweight in the Race category “white” is roughly equal to the missing Hispanic value. Again referring to the Race “White”, Appendix A.1 shows that the sample population is lopsided in a 2:1 gender split favoring males. Normally, genders are relatively equal in number, typically favoring females by a small percent <sub>_(Resident Population Estimates of the United States by Sex, Race, and Hispanic Origin, 2001)_</sub>. These two quirks aside, and given the overall sample size, we accepted this dataset as generally random, and as a representative sample of the population.

<br>

<p align="center"> 
	<img width="652" height="528" src= https://www.dropbox.com/scl/fi/z5ixqcyww5tu8ockirod6/Data-Exploration-Figure-2.png?rlkey=ebmjjxbb6sukvmky5ihqhgft9&st=qb0woyin&raw=1>
</p>

_<p align="center">  Figure 2 and Appendix A.3 </p>_

<br>
<br>

After finding no critical issues with our dataset, we looked at the percentage of individuals at each education level making over $50,000 per year. As expected, the results show a positive trend where the higher the education level, the higher chances of earning more money. Yet there is some noise in this graph. For instance, it does not make sense for a pre-school student to be making any money given labor and education laws, and competency levels, among other issues. 

<br> 

<p align="center"> 
	<img width="689" height="241" src= https://www.dropbox.com/scl/fi/mxwckzsuugx1wlqcucb0u/Data-Exploration-Figure-3.png?rlkey=q865g8w3vuutctf46yktrow7y&st=gi4swj3k&raw=1>
</p>

_<p align="center"> Figure 3 and Appendix A.4 </p>_

<br>
<br>

To account for this, we look at education levels across all age groups sampled. Seen below is a graph of total white population by education levels<sup>2</sup> , which intuitively shows that certain percentages of the population achieve a particular level of education, and stop there until they die. This, despite the noise at the bottom of the graph, can most clearly be seen by the variable “high school grad”, which is the first line under the thick, total population line. In other words, certain segments of the population may have not received a full education, yet have managed to do well for themselves in their adult years. As will be discussed later, this success may also be accounted for by other rationale. 


<br> 

<p align="center"> 
	<img width="696" height="390" src= https://www.dropbox.com/scl/fi/ebrvtyljd8lm6a40cp2s6/Data-Exploration-Figure-4.png?rlkey=mqa8kdiy28rmhrhxwlx1fomcj&st=951a0tvu&raw=1>
</p>

_<p align="center"> Figure 4 and Appendix A.5 </p>_

<br>
<br>

If education could be indicative of wealth, does this apply equally across races and sex? The answer may not be so clear-cut when visualizing. Figures A.6 through A.9 in the appendix show the dispersion of higher education trends higher for the Race “Asian” while “White” and “Black” fall somewhere in the middle, and “Indian/Eskimo” lag behind. However, in the chart below, we see that the average of Black and White earning more than $50,000 per year are very far apart, and further see the gross inequality of the same between males and females<sup>3</sup>.  

<br>

<p align="center"> 
	<img width="698" height="160" src=https://www.dropbox.com/scl/fi/3h9vqientf98tqgv8n6oo/Data-Exploration-Figure-5.png?rlkey=q0tkxcyamvc2ly7drv7vgbcvj&st=0tos19yz&raw=1>
</p>

_<p align="center">  Figure 5 and Appendix A.10 </p>_

<br>
<br>


With the added complexity of gender inequality, we looked at available potential explanatory factors, such as average hours worked. Below, we see that, on average, women worked about 4 hours less than men per week. While this may have some role in the results shown in figure 5, it is clearly not enough to explain the chasm between genders. 

<br>

<p align="center"> 
	<img width="689" height="192" src=https://www.dropbox.com/scl/fi/07hdb7fy3lsz1614luzik/Data-Exploration-Figure-6.png?rlkey=l7u47tq4goq7wedxks9up03kc&st=k3izmgck&raw=1>
</p>

_<p align="center"> Figure 6 and Appendix A.11 </p>_

<br>
<br>

By now, visualization has done its job in demonstrating that inequality does exist, and is perhaps explained by more than one factor. While these charts and figures may be enough for advocacy groups to fight for change, and government to review particular policies, we turned our focus to predictive modeling for a deeper analysis and potentially multiple causal factors.

<br>
<br>


<sup>2</sup> <sub>  Using the category of Race = “White” made visualization of this point easier, because of the large sample size. While other Race categories more or less follow the same trend, their graphs are much more jagged and noisy due to less data. </sub>
<br>
<br>
<sup>3</sup> <sub>  The graph shows each category compared to itself. For example, the blue bar categorized as “Asian Female” is the percent of Asian women who make over $50,000 per year. Thus, each category is out of a total possibility of 100%. The black horizontal line is the average of the whole sample, most likely buoyed by White Males. </sub>

<br> 

# Method 1 – GlmNet

The first and least meaningful method we tested was Glmnet, based on its ability to work with a binary predictor variable. GLMNet differs from Glm in that the method fits a generalized linear model via penalized maximum likelihood, with either lasso or elastic-net regularization, while Glm does not. This model tries to explain as much variance in the data as possible while keeping the model coefficients small. In addition to being fast, it can deal with the problem of sparsity in the input matrix Xi. 

The algorithm of GlmNet is as follows:



<p align="center"> 
	<img width="1200" height="156" src=https://www.dropbox.com/scl/fi/v5wbtfg2h8ac96tjyt82h/GLMNet-Algorithm.png?rlkey=2h25u2rbxxwuajczeht70j992&st=omeuxf03&raw=1>
</p>

<br>

where variable wi is the weight, l is the negative log-likelihood contribution for observation Xi, and α controls the penalty. Regularization parameter lambda (λ) covers the entire range, and penalizes the size of estimated coefficients _(Hastie & Qian, 2014)_.


Using the following code, GlmNet suggested using 2 types of models:

<p align="center"> 
	<img width="330" height="48" src=https://www.dropbox.com/scl/fi/zp2n501sjqxtl99n91el8/GLMNet-Recs.png?rlkey=at8r17hj4hrtbyj1y3v0isens&st=vn7qjkvf&raw=1>
</p>

<br>



To test the predictive power of the model, we choose to split the data as 75% to train and 25% to test. Further, to show the accuracy of the model, we chose to use the Receiver Operating Characteristic (ROC) curve, further known as Area Under the Curve (AUC), as follows:


```
set.seed(3456)
splitIndex <- createDataPartition(census[,outcomeName],
                                  p = .75, list = FALSE, times = 1)

trainDF <- census[ splitIndex,]
testDF  <- census[-splitIndex,]

objControl <- trainControl(method='cv', number=3, returnResamp='none')
objModel   <- train(trainDF[,predictorsNames], trainDF[,outcomeName],
                    method='glmnet', metric = 'RMSE", trControl=objControl)

predictions <- predict(object=objModel, testDF[,predictorsNames])

auc <- roc(testDF[,outcomeName], predictions)
print(auc$auc)

#Area under the curve: 0.8937

```

<br>

<p align="center"> 
	<img width="276" height="271" src=https://www.dropbox.com/scl/fi/kdwtpwnhbbb88w5g2kkd1/GLMNet-AUC.png?rlkey=xz48irtimqcavjntw5jvwv8ws&st=q84gojxz&raw=1>
</p>

_<p align="center"> Area under the curve: 0.8937 </p>_

<br>


There is a lot of information to be derived from the AUC test, of which the most relevant to us is that the area under the curve is a measure of accuracy.  An area of 1 represents a perfect test, and an area of .5 represents a worthless test. _(Kutner, Nachtsheim, & Neter, 2004)_ For GlmNet, the AUC value (accuracy) is 89.75%. 

To help us understand which variables were important in the model derived by GlmNet, we used the function “varlmp” (abbreviation for Variance Importance) in the caret package. The resulting bar chart may have values on both the positive and negative side, which translates to a positive or negative impact on our model:

<br>
<p align="center"> 
	<img width="632" height="412" src=https://www.dropbox.com/scl/fi/pozs3rzd87gp392j9exq7/GLMNet-varimp-output.png?rlkey=iob58sj4k5w28g8zzvpmejhx5&st=3gggh6qi&raw=1>
</p>

<br>


Naturally, this output can be messy when dealing with so many variables. To make a clearer output, the top 22 variables were retained:

<br>
<p align="center"> 
	<img width="774" height="275" src=https://www.dropbox.com/scl/fi/eedn2zdbhjuaajig5dj8a/GLMNet-varimp-output-top-22.png?rlkey=mwf1r3jie429jihk2by35yr2l&st=9dp4pbxx&raw=1>
</p>
<br>


Per the cleaner output, the top influential variable is “Relationship_Wife”.  There may be a few explanations as to why this variable stood out, not limited to a good education, or even reporting dual income, per the below Census snapshot. The second most important variable is “education_Doctorate”. This echoes the result from the data exploration; the better the education, the more likely he/she will have a high paying job. 

<br>
<p align="center"> 
	<img width="358" height="328" src=https://www.dropbox.com/scl/fi/4ot0sod88jn6skum0026g/sample-Census-form-Figure-7.png?rlkey=q74fzroag5ogr2dso0ep94klu&st=wmwvcc64&raw=1>
</p>

_<p align="center"> Figure 7 – sample Census Form <br> (U.S. Department of Commerce: Bureau of the Census, 2000)</p>_


<br>
<br>


# Method 2 - Logistic Regression

Quite often, a research question will contain in the dataset a Y-variable that is binary, or yes/no. Historically, when such a question was being tested, methods such as Linear discriminant function analysis(LDFA) and ordinary least squares (OLS) would be used. However, both methods have strict assumptions surrounding the data, and often these assumptions are violated. For example, OLS assumes linearity and continuity in the dataset. Because of our dummy variables, this would violate the continuity assumption  _(Peng, Lee, & Ingersoll, 2002)_.

To work around these strict assumptions, we turned to the logistic regression model. Logistic models are more apt to work with data which contains both continuous and categorical data, where the decision variable is dichotomous. _(UCLA, 2016)_.

<br>
<p align="center"> 
	<img width="528" height="31" src=https://www.dropbox.com/scl/fi/vekuol3x13o8sbngixir0/Logistic-Regression.png?rlkey=bui6pztpongxyyv217ffql8e2&st=g3gr8qtx&raw=1>
</p>
<br>


Using this regression method in SPSS yielded the following results:

<br>
<p align="center"> 
	<img width="545" height="346" src=https://www.dropbox.com/scl/fi/e05qy10skp78w6dkk8mlt/SPSS-output-1.png?rlkey=ew2velak2j0jy8grcrteazlaa&st=ui2a5vgr&raw=1>
</p>

<p align="center"> 
	<img width="526" height="452" src=https://www.dropbox.com/scl/fi/oiealvnmcbnlhbb4qbhl6/SPSS-output-2.png?rlkey=pe3187hv6y6dbnp0ogiehq4em&st=a3241g0w&raw=1>
</p>
<br>


The first model of the output is a null model, which is to say SPSS fit a model with no predictors. The constant in the table labeled “Variables in the Equation” gives the unconditional log odds of variable admission to the model (i.e., admit=1).

This unfitted model is accompanied by a table labeled “Variables not in the Equation”, which gave the results of a score test known as the Lagrange multiplier test. The column labeled “Score” gave the estimated change in model fit if a term is added to the model, and the other two columns gave the degrees of freedom, and p-value (labeled “Sig.”) for the estimated change. Based on the p-value, almost all of the predictors shown were expected to improve the fit of the model.


The second test (output shown above) gave the overall test and score for a model that includes the predictor variables. The chi-square value of 22879.398, with a p-value of less than 0.0005, suggested that the model as a whole fit significantly better than the null model. 

<br>
<p align="center"> 
	<img width="599" height="525" src=https://www.dropbox.com/scl/fi/c8c10pbd9gfl8a9mdoqhw/SPSS-model-output.png?rlkey=tumvo0ac5snj4wjqzegfjimz4&st=ha6gmnu2&raw=1>
</p>
<br>




Additionally, this output included a classification table, which showed the overall usefulness of the model. As seen above, it accurately predicted/classified about 85% of the observations. In the table labeled “Variables in the Equation”, further diagnostics were given, such as the coefficients, their standard errors, the Wald test statistic with associated degrees of freedom and p-values, and the exponentiated coefficient (also known as an odds ratio). 

Based on the p-values, there were 36 variables shown to be significant, some of which being age, education, native country relationship status, and occupation. This was a large model, so to reduce the dimensionality, we identified the most significant variables by looking at their odds ratio. Based on odds ratio, we found 18 significant variables: 

<br>

| Work Class | Education | Marital Status | Occupation | Native Country | 
|------------|-----------|----------------|------------|----------------|
| Federal Gov't | Doctorate | Married Armed Forces Spouse | Executive / Managerial | Columbia |
| Never Worked | Masters | Married Civilian Spouse | | Holand / Netherlands |
| Private | Preschool | | | Laos |
| Self Employed INC | Professional School | | | Trinidad & Tobago |
| | | | | Vietnam |

<br>

The final output below of interest was the Receiver Operating Characteristic curve. This model produces an ROC Curve accuracy rate of 90.80%, which means that the Logistic Regression model performed slightly better than GlmNet.

<br>
<p align="center"> 
	<img width="405" height="366" src=https://www.dropbox.com/scl/fi/oiq31kgmgv4btz3szf0ea/Logistic-Regression-ROC.png?rlkey=2epv9whrlh247pqtuy5p3uwme&st=p4ebd1o8&raw=1>
</p>
<br>


# Method 3 – Gradient Boosting Machine

The last method we used was the Gradient Boosting Machine Model (GBM). With the versatility in the uses of GBM, a decision was made to use this as a classification method. The way this method works is similar to support vector machines, where it attempts to build a model by splitting the data through a hyperplane. The difference is that GBM is a type of ensemble method. That means that it is an additive model which runs several iterations to build a learning algorithm in a stage-wise manner. The end result is a model that finds a linear association between the past iterations. _(Friedman, 2001)_ The figure below shows a step by step example of this process:

<br>
<p align="center"> 
	<img width="662" height="416" src=https://www.dropbox.com/scl/fi/vdl3q5j92ozwarz7v4dgc/GBM-model-procedure-Figure-8.png?rlkey=zeh0okceel6iof1idedcuodna&st=xmdfz29c&raw=1>
</p>

_<p align="center"> Figure 8 – the GBM Model procedure (Srivastava, 2015) </p>_

<br>

There are many benefits to using this type of machine learning algorithm. The first is that it prevents over fitting by choosing the optimal number of iterations to run through monitoring of prediction error. Gradient boosting is also typically used with decision trees, so there are strategies to overcome over fitting by changing a combination of parameters like the learning rate (shrinkage), depth of tree, and number of trees. With correct tuning parameters, GBM generally provides better results than other ensemble methods such as random forests _(Friedman, 2001)_.

The Gradient Boosted Method was run in R using the gbm and caret packages. The first task was in creating a new variable to force GBM into using the classification mode instead of the original binary dependent variable:

```
# Use gbm by first creating a new classification variable
census$salary2 <- ifelse(salary==1,'yes','no')
census$salary2 <- as.factor(census$salary2)
outcomeName <- 'salary2'
```

From there, the data was split into a test and train set to evaluate the model. Setting a seed guaranteed that we would get the same split in subsequent runs:

```
# Splitting into train and test data
set.seed(1234)
splitIndex <- createDataPartition(census[,outcomeName], p = .75, list = FALSE, times = 1)
trainDF <- census[ splitIndex,]
testDF  <- census[-splitIndex,]
```

Using the caret package, we were able to get the most out of our model by controlling the resampling of the data through cross validation. In this case, we decided to cross-validate the data 10 times, therefore training it 10 times on different portions of the data to make sure we settled on the best tuning parameters. 

Next we created the model and taught it how to recognize whether or not someone made above $50,000 per year: 

```
objControl <- trainControl(method='cv', number=10, returnResamp='none', summaryFunction = twoClassSummary, classProbs = TRUE)
objModel <- train(trainDF[,predictorsNames], trainDF[,outcomeName], 
                  method='gbm', 
                  trControl=objControl,  
                  metric = "ROC",
                  preProc = c("center", "scale"))
```

Below is a sample output of the learning process as the model improved through each iteration. The “TrainDeviance” measures the error, which the model tries to minimize it after each new iteration:

| Iter | TrainDeviance | ValidDeviance | StepSize | Improve |
|------|---------------|---------------|----------|---------|
|1 | 1.0638 | nan | 0.1 | 0.0185 |
|2 | 1.0339 | nan | 0.1 | 0.0149 |
|3 | 1.0099 | nan | 0.1 | 0.0117 |
|4 | 0.9869 | nan | 0.1 | 0.0118 |
|5 | 0.9707 | nan | 0.1 | 0.008 |
|6 | 0.9516 | nan | 0.1 | 0.0095 |
|7 | 0.9357 | nan | 0.1 | 0.0078 |
|8 | 0.9242 | nan | 0.1 | 0.006 |
|9 | 0.915  | nan | 0.1 | 0.0046 |
|10| 0.9024 | nan | 0.1 | 0.0063 |
|20| 0.8335 | nan | 0.1 | 0.0025 |
|40| 0.758  | nan | 0.1 | 0.0009 |
|60| 0.717  | nan | 0.1 | 0.001 |
|80| 0.6925 | nan | 0.1 | 0.0004 |
|100|0.6751 | nan | 0.1 | 0.0004|
|120|0.6634 | nan | 0.1 | 0.0003|
|140|0.6544 | nan | 0.1 | 0.0001|
|150|0.6508 | nan | 0.1 | 0.0001|

<br>

By running a summary of the model, we were given the relative importance of each independent variable, and were able to place weighted importance. It also minimized more than half of our original variables to zero, where we could conclude that they did not have an impact on the boosted method. The first figure below shows the most important factors, which are marital status, capital gain, and capital loss. The second figure indicates that more than half of the variables are classified as unimportant. 


<br>
<p align="center"> 
	<img width="487" height="503" src=https://www.dropbox.com/scl/fi/poycv301kvtvk9y7yvfv2/GBM-Importance.png?rlkey=21d8f9tcl0bvpxwykt1rdwl04&st=43929nzo&raw=1>
</p>
<br>



With the model completed, we were interested in how well it performed. The model was able to classify salary with 86.5% accuracy, by observing the type 1 and type 2 errors highlighted in the confusion matrix below:


```
> #find out accuracy of model
> predictions <- predict(object=objModel, testDF[,predictorsNames], type='raw')
> print(postResample(pred=predictions, obs=as.factor(testDF[,outcomeName])))
 Accuracy     Kappa 
0.8649357 0.5932111


> confusionMatrix(objModel)
Cross-Validated (10 fold) Confusion Matrix 


(entries are percentages of table totals)
 
            Reference
Prediction   no  yes
       no   72.4  9.9
       yes   3.7 14.0
```



Calculating the ROC, we observed that this method performed the best out of the three models used. The graph of the ROC curve also compares GBM in black to the GLMnet method in red. Clearly, GBM has outperformed since it has a larger area:

```
> auc <- roc(ifelse(testDF[,outcomeName]=="yes",1,0), predictions[[2]])
> print(auc$auc)
Area under the curve: 0.9193
```


<br>
<p align="center"> 
	<img width="573" height="401" src=https://www.dropbox.com/scl/fi/cl68eyhj2rhjvmdtcv90d/GLM-ROC.png?rlkey=jxdpkpz4pgy9c23kt0af1oh7s&st=4voczviz&raw=1>
</p>
<br>


# Conclusions and Remarks

Of the three types of models we ran, they all performed very well. Despite a close performance by each model, the Gradient Boosting Machine performed the best. Depending on what is at stake, every additional percentage and even hundredth of a percentage of accuracy can make a big difference. 

| The Model Used | Area Under the Curve (AUC) Score |
|----------------|:---------------------------------:|
| GlmNet | .8975 | 
| Logistic Regression | .9080 | 
| Gradient Boosting Machine (GBM) model | .9193 |

<br>

While there were few similarities between the variables deemed important by each model, the ones which were similar dealt with education levels and marital status. Education is rather intuitive to interpret, as one would expect a higher level of education to be correlated with more specialized fields, which are typically highly paid. 

The marriage level is more difficult to interpret. As seen from the snippet of the Census, there is the possibility that a family who filled out the census reported their income as it was reported on their joint tax return. That is to say that they may not have delineated who earned how much. This creates the several possible scenarios. For example, two spouses could work and jointly earn over $50,000 if the census respondents reported their joint income, where they technically both earn less than $50,000 per year.

The dataset was not without its shortfalls. Not including the “Hispanic” category of race deviated from normal Census reporting, and would have been an interesting feature to measure. Further, the sample size was perhaps too low to more smoothly and accurately look at categories of Race outside of “White”.  Perhaps more interesting is what we didn’t observe. For instance, none of the three models placed a high importance on race, nor on gender, despite visually significant differences between them. This is possibly due to having a dichotomous dependent variable, the effects of marriage and joint income, a combination of the two, or perhaps even other variations which we do not have the expertise to discern.

As a final note, future analysis of the same points (time-series) may be of additional use in terms of tracking trends in the areas we found to matter, such as levels of education achieved by the general population, and the health of the “institution of marriage”. Further, use of this particular model on a future Census dataset can show whether or not there has been a shift in how wealth can be predicted, and if certain social issues still exist.

<br>

# Bibliography and References

## Bibliography
Friedman, J. H. (2001). 1999 Reitz Lecture Greedy Function Approximation: A Gradient Boosting Machine. _The Annals of Statistics_, Vol. 29, No.5, 1189-1232.
<br>
Hastie, T., & Qian, J. (2014, June 26). _Glmnet Vignette_. Retrieved from Stanford: https://web.stanford.edu/~hastie/glmnet/glmnet_alpha.html
<br>
Kutner, M., Nachtsheim, C., & Neter, J. (2004). _Applied Linear Regression Models - 4th Edition_. McGraw-Hill Education.
Mahoney, C. R. (1998). Creating a Culture of Life.
<br>
Peng, C.-Y. J., Lee, K. L., & Ingersoll, M. G. (2002). _An Introduction to Logistic Regression_. Retrieved from Indiana University-Bloomington: http://www-psychology.concordia.ca/fac/kline/734/peng.pdf
<br>
_Resident Population Estimates of the United States by Sex, Race, and Hispanic Origin._ (2001, January 2). Retrieved from U.S. Census Bureau: https://www.census.gov/population/estimates/nation/intfile3-1.txt
<br>
Srivastava, T. (2015, September 11). _Learn Gradient Boosting Algorithm for better predictions (with codes in R)_. Retrieved from Analytics Vidhya: http://www.analyticsvidhya.com/blog/2015/09/complete-guide-boosting-methods/
<br>
U.S. Department of Commerce: Bureau of the Census. (2000, April 1). _United States Census 2000_. Retrieved from Census.gov: https://www.census.gov/dmd/www/pdf/d-61b.pdf
<br>
UCLA. (2016). _SPSS Data Analysis Examples Logit Regression_. Retrieved from Institute for Digital Research and Education: http://www.ats.ucla.edu/stat/spss/dae/logit.htm
<br>
University of California Irvine. (1994). _Census Income Data Set_. Retrieved from UCI Machine Learning Repository: http://archive.ics.uci.edu/ml/datasets/Census+Income

<br>

## Reference

Cover Image of Uncle Sam and the Census book was pulled from http://backstoryradio.org/files/2010/10/answersready.jpg. The full image can be found in the government archives at http://loc.gov/pictures/resource/cph.3g08370/.

<br>

# Appendix


### Figure A.1

<p align="center"> 
	<img width="703" height="567" src=https://www.dropbox.com/scl/fi/6whg0zwlna2rcpw63l3la/Appendix-A1.png?rlkey=eolsg4aa6s5qr838i9ukyrx6s&st=1gqzjr9y&raw=1>
</p>
<br>


### Figure A.2

<p align="center"> 
	<img width="587" height="305" src=https://www.dropbox.com/scl/fi/2u192shau89talohgedt1/Appendix-A2.png?rlkey=u50b0j2kkh9upxctbvkyg0ddh&st=i9siiroi&raw=1>
</p>
<br>


### Figure A.3

<p align="center"> 
	<img width="658" height="512" src=https://www.dropbox.com/scl/fi/gw00zjeunuxt9sp6lgy5s/Appendix-A3.png?rlkey=dwry6q697jl9ftftt6fyqqgw1&st=z2chx8cr&raw=1>
</p>
<br>


### Figure A.4

<p align="center"> 
	<img width="694" height="248" src=https://www.dropbox.com/scl/fi/jhairot1w4o8svvfq3xg7/Appendix-A4.png?rlkey=ch77iqb5lqn97hd4h4wjjl9z0&st=zfcafv4a&raw=1>
</p>
<br>


### Figure A.5

<p align="center"> 
	<img width="699" height="393" src=https://www.dropbox.com/scl/fi/6nvmx6mf99owjsrgsdij0/Appendix-A5.png?rlkey=4qrixh5qswfxi3ulvavimbppz&st=vgqbf377&raw=1>
</p>
<br>


### Figure A.6

<p align="center"> 
	<img width="508" height="498" src=https://www.dropbox.com/scl/fi/aadmpiwv3d8mqgonyexi0/Appendix-A6.png?rlkey=mrbcnwutofbyqy1pg8l6wncxy&st=cpgamk3a&raw=1>
</p>
<br>


### Figure A.7

<p align="center"> 
	<img width="485" height="407" src=https://www.dropbox.com/scl/fi/dosxheqlilq20vbfadxul/Appendix-A7.png?rlkey=gql8vijqx2nsk3jaon827j308&st=bzztg39t&raw=1>
</p>
<br>


### Figure A.8

<p align="center"> 
	<img width="561" height="506" src=https://www.dropbox.com/scl/fi/hp2m41fhodwwvct7dyt30/Appendix-A8.png?rlkey=izay9bkz4znlheqayv2uzbucy&st=vuuwi0we&raw=1>
</p>
<br>


### Figure A.9

<p align="center"> 
	<img width="572" height="454" src=https://www.dropbox.com/scl/fi/azuuyscia4enzr09n4shi/Appendix-A9.png?rlkey=7botngsi0v1d9rkww5qv8wfad&st=a8bjj6rp&raw=1>
</p>
<br>


### Figure A.10

<p align="center"> 
	<img width="206" height="868" src=https://www.dropbox.com/scl/fi/ysnkxo0pe4mjvvlazjgj2/Appendix-A10.png?rlkey=wdq8geuxsh613v01emaimobkx&st=2426b03i&raw=1>
</p>
<br>


### Figure A.11

<p align="center"> 
	<img width="247" height="857" src=https://www.dropbox.com/scl/fi/2k8kz7mvm6jfy4yj8nrjd/Appendix-A11.png?rlkey=0jpgpl8z3ihkb8wjckeb3l256&st=g94pvwd5&raw=1>
</p>
<br>


