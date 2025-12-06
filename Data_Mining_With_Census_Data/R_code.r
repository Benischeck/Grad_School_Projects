##############################
### STAT 642 Final Project ###
###         Group 1        ###
##############################

#######################################################################
### Define dependent variable as a true binary                      ###
###                                                                 ###
###       0 = Under 50,000                                          ###
###       1 = Over  50,000                                          ###
###                                                                 ###
#######################################################################

################################
### Packages to be installed ###
################################

install.packages("plyr")
install.packages("readxl")
install.packages("caret")
install.packages("gbm")
install.packages("pROC")
install.packages("glmnet")
install.packages("party")
install.packages("aod")
install.packages('e1071', dependencies=TRUE)
install.packages("tree")
install.packages("xlsx")

##############################
### libraries to be called ###
##############################

library(plyr)
library(readxl)
library(caret)
library(gbm)
library(pROC)
library(glmnet)
library(party)
library(aod)
library(e1071)
library(tree)
library(rpart)
library(xlsx)
library(ggplot2)
library(Rcpp)

###########################
### Import the datafile ###
###########################

census <- read_excel("E:/STAT 642/Class Project/Census Full.xlsx") ### original dataset
  

write.csv(census, "census.csv")
########################
### define variables ###
########################


age <- census$Age
work <- census$Workclass
wgt <- census$fnlwgt
edu <- census$education
edunum <- census$`Education-num`
marital <- census$`marital-status`
occu <- census$occupation
relat <- census$relationship
race <- census$race
sex <- census$sex
gain <- census$`capital-gain`
loss <- census$`capital-loss`
hours <- census$`hours-per-week`
native <- census$`native country`
salary <- census$salary


################################
### creating dummy variables ###
################################

work <- as.factor(work)
edu <- as.factor(edu)
marital <- as.factor(marital)
occu <- as.factor(occu)
relat <- as.factor(relat)
race <- as.factor(race)
sex <- as.factor(sex)
native <- as.factor(native)
censusdummy <- dummyVars("~.",data=census, fullRank=F)
census <- as.data.frame(predict(censusdummy,census))
outcomeName <- 'salary'
predictorsNames <- names(census)[names(census) != outcomeName]



###############################################
### Perform some basic analysis on the data ###
###############################################

plot(original$sex)
plot(original$salary, original$sex)
education <- factor(original$education, levels=c("Preschool" , "1st-4th" , "5th-6th" , "7th-8th" , "9th" , "10th" , "11th", "12th",
                                                  "HS-grad" , "Some-college" , "Assoc-acdm" , "Assoc-voc" , "Bachelors" , "Prof-school" ,
                                                 "Masters" , "Doctorate"))
plot(original$education, original$sex)

plot(original$relationship, col = rainbow(6) , ylim = c(0,15000) ,
      xlab = "Status" , cex.lab = 1 , cex.axis = 0.5)


#proportion of our outcome variables
prop.table(table(salary))
prop.table(table(relat))
prop.table(table(edu))





###############################################
### run a logistic regression - needs work  ###
###############################################

dropset <- names(census) %in%  c(census$`education-num` , census$fnlwgt)
newcensus <-census[!dropset]
Train <- createDataPartition(salary, p=0.75, list=FALSE)
training <- census[ Train, ]
testing <- census[ -Train, ]
training$`education-num` <- factor(training$`education-num`)
mod_fit <- glm(training$salary ~ . -fnlwgt, family = "binomial", data = training)

summary(mod_fit)



#logistic regression

Train <- createDataPartition(salary, p=0.75, list=FALSE)
training <- census[ Train, ]
testing <- census[ -Train, ]




#######################################################
### Run Gradient Boosting Method - fully functional ###
#######################################################


#use gbm by first creating a new classification variable
census$salary2 <- ifelse(salary==1,'yes','no')
census$salary2 <- as.factor(census$salary2)
outcomeName <- 'salary2'

#splitting into train and test data
set.seed(1234)
splitIndex <- createDataPartition(census[,outcomeName], p = .75, list = FALSE, times = 1)
trainDF <- census[ splitIndex,]
testDF  <- census[-splitIndex,]

#cross-validate
objControl <- trainControl(method='cv', number=3, returnResamp='none', summaryFunction = twoClassSummary, classProbs = TRUE)
objModel <- train(trainDF[,predictorsNames], trainDF[,outcomeName], 
                  method='gbm', 
                  trControl=objControl,  
                  metric = "ROC",
                  preProc = c("center", "scale"))

#find out what variables were most important:
summary(objModel)
#find out what tuning parameters were most important to the mode
print(objModel)

#find out accuracy of model
predictions <- predict(object=objModel, testDF[,predictorsNames], type='raw')
print(postResample(pred=predictions, obs=as.factor(testDF[,outcomeName])))

predictions <- predict(object=objModel, testDF[,predictorsNames], type='prob')
head(predictions)

#area under curve (AUC)
auc <- roc(ifelse(testDF[,outcomeName]=="yes",1,0), predictions[[2]])
print(auc$auc)

#confusion matrix
confusionMatrix(objModel)

###########################################
### Lasso Regression - fully functional ###
###########################################

#GLMnet Modeling
outcomeName1 <- 'salary'

set.seed(1234)
splitIndex1 <- createDataPartition(census[,outcomeName1], p = .75, list = FALSE, times = 1)
trainDF1 <- census[ splitIndex1,]
testDF1  <- census[-splitIndex1,]

objControl1 <- trainControl(method='cv', number=3, returnResamp='none')
objModel1 <- train(trainDF[,predictorsNames], trainDF[,outcomeName1], method='glmnet',  metric = "RMSE", trControl=objControl1)

predictions1 <- predict(object=objModel1, testDF[,predictorsNames])

auc1 <- roc(testDF[,outcomeName1], predictions1)
print(auc1$auc)

plot(varImp(objModel1,scale=F))


#######################
###experimental code###
#######################

y <- census$salary
x <- as.matrix(census[, -109])

is.nan.data.frame <- function(x)
do.call(cbind, lapply(x, is.nan))
x[is.nan(x)] <- 0

fitty <- glmnet(x,y)
