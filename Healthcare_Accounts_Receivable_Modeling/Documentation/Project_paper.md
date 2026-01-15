<div align="center" id="user-content-toc">
  <ul align="center" style="list-style: none;">
    <summary>
      <h1>California Office of Statewide Health Planning and Development: Modeling Accounts Receivable to Predict Abnormal Cost Centers</h1>
    </summary>
  </ul>
</div>


<br>


<p align="center"> 
	A group effort by Tommy Baw, John Benischeck, Jordan McIntyre
</p>

# Table of Contents

- Abstract
- Introduction
- Data Gathering
- Data Cleaning
- Data Calculation
- Data Exploration
- Linear Modeling and Model Reduction
- Model Diagnostics
- Robustness Check
- Conclusion
- References

<br>

<br>

# Abstract

Through the exploration and linear modeling of the California office of Statewide Health Planning data, we look to find predictors of the dependent variable Accounts Receivable. Accurately predicting future Accounts Receivable and, by association, the Loss Reserves, afford hospitals a greater efficiency in financial planning. The paper will discuss variable selection and calculation, along with observation inclusion and deletion, as well as variable transformations. Simple linear regression modeling, including the Stepwise method, will be employed to model the variables. To judge the robustness of the model, we will analyze the residuals and outliers through various tests, along with the use of the model with a new, test dataset.  

<br>

<br>

# Introduction

Hospitals and, more importantly, those who work in them, face daily uncertainties. What are the chances of an incorrect diagnosis? Manifestation of side effects of a treatment? What about the financial uncertainties a hospital faces? The healthcare community is highly fractured in functionality and seemingly prices its respective products and services arbitrarily<sup>1</sup>. Financial planning, in the face of such uncertainty, is difficult. Without good financial planning, a hospital could go bankrupt very quickly. How can pro-forma – the estimated future financial performance of a company - be estimated accurately? 

One way to make this pro-forma process easier is to control expenses. Hospitals know statistically how much a consultation or procedure or other service will cost. What they do not know is how many of each will be administered in a given time period. This means that revenue will fluctuate, as well as a cost variable known as accounts receivable. Accounts receivable is simply the outstanding debts owed to the hospital. For example, insurance may cover only some of the cost of a procedure, and a copay is owed, which has not yet been paid. The copay would be considered a part of the hospital’s accounts receivable. Like all businesses, there will be a certain percentage of clients (patients) who either cannot or do not pay their bills. To cover these losses, hospitals set aside funds in a category called loss reserves. Loss reserves are usually set as a percentage of estimated accounts receivable for a period.

The aim of this paper is to explore the California Office of Statewide Health Planning and Development’s (OSHPD) 2011-2012 data using regression analysis for potential predictors of accounts receivable, in order to more accurately predict the needed loss reserves. By more accurately predicting this cost, the hospital can more efficiently allocate funds to increase bottom dollar (profit). 

<br>
1<sub>http://www.uta.edu/faculty/story/2311/Misc/2013,2,26,MedicalCostsDemandAndGreed.pdf</sub>

<br>
<br>


# Data Gathering

For this project, we have used the OSHPD online repository to collect the raw datasets for analysis. We chose to use the 2011-2012 dataset for our training data, and the 2012-2013 data for our test set. Each dataset contained two tabs: one named “Financial and Utilization Data” and a second called “Cost Allocation Data”. Our focus was solely on the variables in the former tab. Due to the size of the dataset, we selected 20 variables we thought might be good predictors of accounts receivable:


<br>   
<ul align="center"> 
    <strong> <h3> Table 1: Chosen Variables </h3> </strong>
    
</ul>



<p align="center"> 

| Variable | Variable Name in Datasets | Type |
|:--------:|---------------------------|------|
| X1 | Type of Control_Church | Binary (1 = yes) |
| X2 | Type of Control_Non-Profit Corporation | Binary (1 = yes) |
| X3 | Type of Control_Non-Profit Other | Binary (1 = yes) |
| X4 | Type of Control_Investor - Individual | Binary (1 = yes) |
| X5 | Type of Control_Investor - Partnership | Binary (1 = yes) |
| X6 | Type of Control_Investor - Corporation | Binary (1 = yes) |
| X7 | Type of Control_State | Binary (1 = yes) |
| X8 | Type of Control_County | Binary (1 = yes) | 
| X9 | Type of Control_City/County | Binary (1 = yes) |
| X10 | Type of Control_City | Binary (1 = yes) |
| X11 | Type of Control_District | Binary (1 = yes) |
| X12 | Available Beds (Average) | Continuous |
| X13 | Residents_Total | Continuous |
| X14 | Trauma Center? | Binary (1 = yes) |
| X15 | Income Statement_Gross Patient Revenue | Continuous |
| X16 | Productive Hour Precentage | Continuous |
| X17 | Avg Length of Stay (including LTC) | Continuous |
| X18 | (Occupancy Rate (available beds)) | Continuous |
| X19 | operating rooms | Continuous |
| X20 | Loss Reserves | Continuous |
| Y1  | Accounts Receivable | Continuous |

</p>

<br>
<br>

# Data Cleaning

To clean the dataset, where the value of ‘0’ could not be imputed (namely in the dependent variable column), the observation was deleted. This makes sense intuitively, because hospitals should have a revenue greater than zero, or else it would imply that the hospital accepted zero patients. Further, certain functions of R do not handle blank observations well and would otherwise remove the observation from calculations. Systemically, the Kaiser hospital and Shriner hospital observations has missing Accounts Receivable in both training and test datasets, and were removed from the dataset. Select others (non-systemic) were removed under the same criteria. The end result was a training dataset of 387 observations and a test dataset of 390 observations. 

<br>

<br>

# Data Calculation

Some of the variables in our dataset were created through formulas contained in the data guide from the OSHPD website<sup>2</sup>, and others were simply collapsed variables. The Trauma Center variable was collapsed from 4 binary variables to 1. We made the assumption that, for our model predictions, there would be no difference between the types of trauma centers, and that it would suffice to say simply whether or not a hospital had a trauma center. Productive Hour Percentage was calculated as (PROD_HRS / (PROD_HRS + NON_PRD_HR)), where PROD_HRS and NON_PRD_HR were calculated based on the instruction sheet. Avg Length of Stay (including LTC), Loss Reserves, Accounts Receivable, and Operating Rooms were all calculated based on the instruction sheet.

<br>

2<sub>http://www.oshpd.ca.gov/HID/Products/Hospitals/AnnFinanData/HAFDDoc2013.pdf</sub>

<br>

<br>


# Data Exploration

With the variables relevant to the study chosen, calculated, and cleaned, histograms of the variables were run to observe their distributions. Below are the variables that appeared to require transformations. Figure 1 shows the dependent variable, Accounts Receivable, which is highly right skewed. A log transformation was performed to make it more normally distributed (Figure 2). From there, the descriptive statistics were run to explore the independent variables. Referring to Table 1, only non-binary variables were taken into account. In order to avoid scaling issues, a closer look was given to x15 and x20.  The variable x15 represents Gross Patient Revenue where the mean is much larger than the other variables. In order to have the model place a more equal weight to each independent variable, a log transformation was performed as referenced below. Variable x20 will be discussed in the following section.

<br>

```
> summary(hos$x15)
     Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
2.239e+06 9.455e+07 3.610e+08 7.472e+08 1.065e+09 8.989e+09 

> summary(log(hos$x15))
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  14.62   18.36   19.70   19.46   20.79   22.92
```

<br> 

<br> 


<br>   
<ul align="center"> 
    <strong> <h3> Figure 1: Histogram of Y &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Figure 2: Histogram of Transformed Y </h3> </strong>
    
</ul>

<p align="middle">
  <img width="347" height="292" src= https://www.dropbox.com/scl/fi/ar3oemz56a6zmew28qdoq/Figure-1-Histogram-of-Y.png?rlkey=28ti6e56onmpoas79ax2cmsea&st=w1ft4yu4&raw=1>
  <img width="347" height="292" src= https://www.dropbox.com/scl/fi/f6v40xhsvhx4w65lyqxb9/Figure-2-Histogram-of-Transformed-Y.png?rlkey=683vqgwkailydssjzjba4lkxj&st=ihika6f1&raw=1>
</p>

<br>

<br>

<ul align="center"> 
    <strong> <h3> Figure 3: Histogram of X15 &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Figure 4: Histogram of Transformed X15
 </h3> </strong>
    
</ul>

<p align="middle">
  <img width="347" height="292" src=https://www.dropbox.com/scl/fi/ea0x546ouphkwr12tpxbd/Figure-3-Histogram-of-X15.png?rlkey=dh39hcp58hevraovlkga71fei&st=qhrsskgd&raw=1>
  <img width="347" height="292" src=https://www.dropbox.com/scl/fi/p14ttpqmie93v677iwfxj/Figure-4-Histogram-of-Transformed-X15.png?rlkey=w71ekurt1iwz2zktzwegjgr1x&st=ckstoewo&raw=1>
</p>

<br>

<br>


<ul align="center"> 
    <strong> <h3> Table 2: Descriptive Statistics </h3> </strong>
    
</ul>


<p align="center"> 
	<img width="730" height="234" src=https://www.dropbox.com/scl/fi/hrwxb90d53wgvy5vpoitz/Table-2-Descriptive-Statistics.png?rlkey=erfx7ymzb8kx0om21y0785h25&st=fjxttwyd&raw=1>
</p>


<br>

<br>

We explored further by taking a look into the correlation and scatterplot matrix. The purpose is to visualize the relationships between variables and to avoid multicollinearity. X20 was discussed above when looking at the scalability of the data. In the correlation matrix, x20 is highly correlated with the dependent variable, with a value of 0.987. X20 is the amount put aside in loss reserves while the dependent variable is accounts receivable so it is logical that there is a high correlation between the two. The decision was made to remove X20 from the model and confirmed when running the linear regression. The other variable of concern was the relationship between gross revenue (x15) and number of operating rooms (x19). This positive relationship exists as number of operating rooms normally correlates to the size of the hospital, and larger hospitals typically will produce more revenue. However, both were kept in the model as it was observed that not all hospitals had operating rooms and both could be important factors when seeing how they affect accounts receivable. The scatterplot matrix did not indicate any new information that was not already addressed. 

<br>

<br>


<ul align="center"> 
    <strong> <h3> Table 3: Correlation Matrix </h3> </strong>
    
</ul>


<p align="center"> 
	<img width="716" height="320" src=https://www.dropbox.com/scl/fi/ww3eeaje2860w0ug64d2p/Table-3-Correlation-Matrix.png?rlkey=zfcy92j4undpwko58sxd90408&st=l6jpx0yj&raw=1
</p>


<br>

<br>



<ul align="center"> 
    <strong> <h3> Table 4: Scatterplot Matrix </h3> </strong>
    
</ul>


<p align="center"> 
	<img width="591" height="454" src=https://www.dropbox.com/scl/fi/4le5vnx8yar0s1fejiggd/Table-4-Scatterplot-Matrix.png?rlkey=gmihwtp64ndt4by3mrrzrtiun&st=x41p2wuo&raw=1>
</p>


<br>

<br>

# The Linear Model and Model Reduction

Several linear regression models were completed to test the assumptions referenced above and to find the best fitting model. First, the full model was run to see the initial R<sup>2</sup>:

```
lm(yt~x1+x2+x3+x4+x5+x6+x7+x8+x9+x10+x11+x12+x13+x14+x15+x16+x17+x18+x19, data=hos)
```

<br>

With an R<sup>2</sup> value of 0.6399, there was clearly room for improvement. As stated during our data exploration, a log transformation on Gross Patient Revenue (x15) was performed to normalize the disproportionately weighted independent variables. The following model, now using log(x15), ran with an improved R2 of 0.8663 where the significant variables at α=0.05 are County Hospitals (x8), Average Available Beds (x12), Gross Patient Revenue (log[x15]), Average Length of Stay (x17), and Occupancy Rate of Beds (x18).


```
lm(yt~x1+x2+x3+x4+x5+x6+x7+x8+x9+x10+x11+x12+x13+x14+log(x15)+x16+x17+x18+x19, data=hos)
```

<br>

To see how well this model performs, a Step-wise regression model was also performed to see how many variables could be removed from the model while still retaining a relatively high R<sup>2</sup>. The model is as follows:

```
Yt=1.607 + 0.201x1 + 0.121x2 + 0.245x5 - 0.131x6 + 0.894x8 + 0.001x12 + 0.001x13 + 0.823log x15 - 0.002x17 - 0.005x18
```

<br>

The Step-wise regression gave the same exact significant variables at α=0.05 while removing eight variables from the model. By significantly reducing the complexity of the model and only losing 0.001 variation explanation, The R<sup>2</sup> of 0.865 makes this a reasonable model to use.


<br>

<br>

# Model Diagnostics

Looking at the residual plot in Figure 5 of the next page shows the observations evenly around the 0-axis. The residual and QQ plot does not appear to violate any assumptions, though observation 252 might be a potential outlier. To detect these possible outliers, we next calculated DFFITS, DFBETAS, and Cooks Distance.

<br>

<ul align="center"> 
    <strong> <h3> Figure 5: Residual Plot </h3> </strong>
    
</ul>


<p align="center"> 
	<img width="586" height="411" src=https://www.dropbox.com/scl/fi/6r43146zoqoau9muhv5b2/Figure-5-Residual-Plot.png?rlkey=1vq9u5nfw3ukjcupigw2vx8h9&st=sbitf49u&raw=1>
</p>


<br>

<br>


<ul align="center"> 
    <strong> <h3> Figure 6: QQ Plot </h3> </strong>
    
</ul>


<p align="center"> 
	<img width="586" height="411" src=https://www.dropbox.com/scl/fi/2xxwjaa0hbtqnej8ev6eb/Figure-6-QQ-Plot.png?rlkey=uoidwx57jfuqgty0xj8z5s4h6&st=1xac0bni&raw=1>
</p>


<br>

<br>

Several outlier tests were run (DFFITS, DFBETAS, Cooks Distance), and some influential points were identified, but ultimately not dropped from the data. DFFITS outlier test revealed several hospitals that could be seen as outliers under the definition of |DFFITS| > 2. |DFFITS| >0.44315057141 gave us the six potential outliers. However, if using the less strict |DFFITS| >1 method, only one observation, ALTA BATES SUMMIT MEDICAL CENTER, would be seen as an outlier.

Taking a look at Cooks Distance, several observations appear to be influential using the Cooks Distance > 4/n. However, and as observed in the DFFITS test, only one hospital had a value greater than 1- ALTA BATES SUMMIT MEDICAL CENTER (6.590936).

<br>


<ul align="center"> 
    <strong> <h3> Figure 7: Leverage Plot </h3> </strong>
    
</ul>


<p align="center"> 
	<img width="445" height="326" src=https://www.dropbox.com/scl/fi/46nxyb2z9e0mnpczy8dyi/Figure-7-Leverage-Plot.png?rlkey=tx89an8jp6xckxj1zoh3oxc2g&st=4sdz2igc&raw=1>
</p>


<br>

<br>

Since, ALTA BATES SUMMIT MEDICAL CENTER is a very large hospital, we did not want to excluded it from the data set. Additionally, and supporting its inclusion in the model, the residual vs. fitted plot did not identify Alta Bates as a potential outlier.

<br>

<br>

# Robustness Check

To further test the robustness of the trained model, we used the 2012-2013 test set to test the model’s predictive power. As a measure of how well the trained model performed with the test set, we used the Root Mean Square Error (RMSE) metric.  Running the model on the train set yielded an RMSE of 17.60591, which fell around the middle of the range of the dependent observations. Using the test data, RMSE yielded a value of 13.71048, close to the bottom of the dependent observation range. Generally speaking, the lower RMSE value on our test set means that the model performed well in predicting the test set.

<br>

<br>

# Conclusion

Given the independent variables used, we found a relatively strong and robust model to predict the value of accounts receivable. The model has a relatively accurate accounting of variance with an R<sup>2</sup> of 0.865, and seems to perform well with new data. However, many of the variables which our analysis found to be important are relatively intuitive to interpret. Our final model is as follows:

<br>

Y=e<sup>1.607+0.201x1+0.121x2+0.245x5-0.131x6+0.894x8+0.001x12+0.001x13+0.823log x15 -0.002x17-0.005x18 </sup>

<br>


<br>   
<ul align="center"> 
    <strong> <h3> Table 4: List of Final Model Variables </h3> </strong>
    
</ul>



<p align="center"> 


| Variable | Variable Name in Datasets | Type |
|:--------:|---------------------------|------|
| X1 | Type of Control_Church | Binary (1 = yes) |
| X2 | Type of Control_Non-Profit Corporation | Binary (1 = yes) |
| X5 | Type of Control_Investor - Partnership | Binary (1 = yes) |
| X6 | Type of Control_Investor - Corporation | Binary (1 = yes) |
| X8 | Type of Control_County | Binary (1 = yes) | 
| X12 | Available Beds (Average) | Continuous |
| X13 | Residents_Total | Continuous |
| X15 | Income Statement_Gross Patient Revenue | Continuous |
| X17 | Avg Length of Stay (including LTC) | Continuous |
| X18 | (Occupancy Rate (available beds)) | Continuous |

</p>

<br>

<br>

In interpreting these results, we see, for instance, that Available Beds and Gross Patient Revenue point to the size of the hospital. Intuitively, the bigger the hospital, the more revenue they are likely to make, meaning that the accounts receivable will be higher. 

Similarly, we understand the inverse relation of Average Length of Stay to mean that if more patients stay longer, there are less overall people the hospital can treat and subsequently less people who would not pay their bills. Another interpretation is that those staying longer may have insurance covering their stay, meaning that the hospital has less concern about collecting those related costs. Likewise, a higher Occupancy Rate (available beds) means that the more open beds there are, the less patients the hospital is serving, leading to a lower accounts receivable.

Number of residents can be either interpreted as a sign of the size of the hospital, or that it is a learning hospital. In either case, we may assume that there are extra costs associated with teaching, thus leading to a higher accounts receivable. 

Perhaps the most difficult to interpret are how the types of hospitals (church, non-profit, etc) contribute to the amount of accounts receivable. For future studies, it may be worth looking at variables which are related to the size and location of these hospitals, as well as more detailed financial metrics such as Receivables Turnover Ratio (how long it takes a hospital to collect its debts on average). This might provide hospitals with insight on how to more effectively handle their accounts receivable.

Given the roughly 17,000 variables contained in the datasets, having the help of a healthcare subject matter expert may help us better identify the more uncommon variables to test for correlation and causation of accounts receivable. Also, an SME would be good to consult regarding the variable of revenue. Revenue is typically used as a part of models calculating predicted accounts receivable. That means, however, using the previous year’s revenue to calculate current needs. In practice, the question becomes whether or not to re-build the 2011-2012 dataset with the same variables and replacing patient revenue with that of the 2010-2011 (prior year) dataset. For this model, given the high correlation between the current year revenue and accounts receivable, we made the assumption that the current year revenue could stand in for prior year.

<br>

<br>

# References

All data was use from the OSHPD website:

	http://www.oshpd.ca.gov/HID/Hospital-Financial.asp


Interpretation and calculation of columns was guided by the OSHPD data manual:

	http://www.oshpd.ca.gov/HID/Products/Hospitals/AnnFinanData/HAFDDoc2013.pdf


Interpreting RMSE:

Karen. (n.d.). Assessing the Fit of Regression Models. Retrieved from The Analysis Factor: http://www.theanalysisfactor.com/assessing-the-fit-of-regression-models/

