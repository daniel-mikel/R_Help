# Choosing Explanitory Variables
# This is part three in a datacamp tutorial
	#https://campus.datacamp.com/courses/statistical-modeling-in-r-part-1/designing-training-and-evaluating-models?ex=1

# libraries used:
library("mosaicData")
library("statisticalModeling")
library("rpart")


# Design choices in statistical models
	# the data to use for training
	# the explanitory variables
	# the model architecture: lm(), rpart(), and others

# Consider some examples for application
	# in medicine you test if a treatment will help a patient
	# in commerce you want to present choices to customers that they are likely to find attractive
	#  in setting policy, you might want to know how a given reform will affect results

# Applying Statistical Models
	# take whatever information is available to make a prediction of what will happen
	# construct an apparatis from which you can run experiments
	# explore a mass of data to identify relationships among variables

# Basic choices in model architecture
	# catagorical response variables (e.g. yes or no, infected or not)
		# use rpart()
	# if the response variable is numerical
		# use lm() or rpart()

# lm() is the most common choice of model for both good and bad reasons
	# it is good at relationships that are gradual and prpoportional
	# rpart() is useful for dichotomous, discontinuous varibles

# Comparnig prediction results for variable selection
	# specify two models and compare their predictive power (one with and one without the variable being considered)

# for instance, suppose a predictive model of wages
	# we want to decide whether to use 'age' as an explanitory variable
	# if the model that uses Age works better, then that is an indication that we might want to use 'age' in the model.

# how to measure how closely your model is predicting ouputs?
	# subtract the function output from the actual response values in the testing data
		# the result is called the prediciton error
		# with one error for every case in your testing data
	# then summarize your prediction error  
	# best way to summarize your prediction errors is the mean of the square fo the prediction errors

# Running Experience

# we'll start with the cherry blossom running data
	# note: can't find this data
	# can find the "Runners" dataset in library(statisticalModeling) but not Runners_100

# first we'll build a linear model "net" of running time using the explanitory variables "age" and "sex"
	# then we'll use the runners previus experience to improve the model predictions
	# we'll use this data in the "previous" argument in addition to "age" and "sex"

# Build a model of net running time
base_model <- lm(net ~ age + sex, data = Runners_100)

# Evaluate base_model on the training data
base_model_output <- predict(base_model, newdata = Runners_100)

# Build the augmented model
	# the "previous" argument seems to show if the runner participated in past races
aug_model <- lm(net ~ age + sex + previous, data = Runners_100)

# Evaluate aug_model on the training data
aug_model_output <- predict(aug_model, newdata = Runners_100)

# How much do the model outputs differ?
	# mean of differences squared
mean((aug_model_output - base_model_output) ^ 2, na.rm = TRUE)

# Build and evaluate the base model on Runners_100
base_model <- lm(net ~ age + sex, data = Runners_100)
base_model_output <- predict(base_model, newdata = Runners_100)

# Build and evaluate the augmented model on Runners_100
aug_model <- lm(net ~ age + sex + previous, data = Runners_100)
aug_model_output <- predict(aug_model, newdata = Runners_100)

# Find the case-by-case differences
base_model_differences <- with(Runners_100, net - base_model_output)
aug_model_differences <- with(Runners_100, net - aug_model_output)

# Calculate mean square errors
mean((base_model_differences) ^ 2)
mean((aug_model_differences) ^ 2)

# Prediction Preformance
	# knowing that your models make different predictions doesn't tell you which model is better.
	# here we compare how the models output to the actual observed output
		# the term 'error' or 'prediction error' is often used, rather than just 'difference'
	# so we'll refere to this as the 'mean square error', instead of the 'mean square difference'

# Build and evaluate the base model on Runners_100
base_model <- lm(net ~ age + sex, data = Runners_100)
base_model_output <- predict(base_model, newdata = Runners_100)

# Build and evaluate the augmented model on Runners_100
aug_model <- lm(net ~ age + sex + previous, data = Runners_100)
aug_model_output <- predict(aug_model, newdata = Runners_100)

# Find the case-by-case differences
base_model_differences <- with(Runners_100, net - base_model_output)
aug_model_differences <- with(Runners_100, net - aug_model_output)

# Calculate mean square errors
	# the smaller the mean squared error, the closer the model's outputs were to the actual response variable 
mean((base_model_differences) ^ 2)
mean((aug_model_differences) ^ 2)

# Where's the Statistics

# we've only seen part of the technique for using Mean Squared Errors (MSE) to decide if we should include an additional explanitory variable
	# we will see that, as you add an additional variable, it will almost always give a model smaller prediction errors!
	# it might be that the added varaible genuinely contributes to the quality of predictions
	# a video expaining:
		# https://campus.datacamp.com/courses/introduction-to-statistical-modeling-sidebars/sidebar-videos?ex=4
	# when selecting explanitory variables, our null hypothesis should be that the explanitory variables have no effect on the response variable
		# then we compare the results of the explanitory variables to the results if the explanitory variables were true.
		# you then compare the results of the explanitory model to those of a model where the null hypothesis were true. e.g.
			# model <- lm(response_variable ~ NULL, data = <data>)
		# if the differences are large, then we reject the null hypothesis and accept the explanitory variables
	# for example

null_model <- lm(wage ~ NULL, data = CPS85)
model_one <- lm(wage ~ sector, data = CPS85)

mean((CPS85$wage - predict(null_model))^2)
mean((CPS85$wage - predict(model_one))^2)

	# later we'll learn how to utilize testing data, compare degrees of freedom, or to test using discounts for explanitory variables
	# just using this as a measure of a models effectiveness is pretty poor, as pretty much any model will beat the null hypothesis in MSE

# Add bogus column to CPS85 (don't change)
  # we add a column of totally random logical outputs (TRUE and FALSE) 
CPS85$bogus <- rnorm(nrow(CPS85)) > 0

# Make the base model
base_model <- lm(wage ~ educ + sector + sex, data = CPS85)

# Make the [bogus] augmented model
aug_model <- lm(wage ~ educ + sector + sex + bogus, data = CPS85)

# Find the MSE of the base model
mean((CPS85$wage - predict(base_model, newdata = CPS85)) ^ 2)

# Find the MSE of the augmented [bogus] model
mean((CPS85$wage - predict(aug_model, newdata = CPS85)) ^ 2)

# and the difference is:
	# MSE(base) - MSE(bogus) = 0.0106
	# meaning the bogus model had a LOWER standard error, implying that it was better at explaining the response variable 
mean((CPS85$wage - predict(base_model, newdata = CPS85)) ^ 2) - mean((CPS85$wage - predict(aug_model, newdata = CPS85)) ^ 2)

# Cross Validation

# now we want to compare two actual models
	# we start by dividing the data into two non-overlying sets
	# some will go into a training set, and the rest into a testing set
	# then we use them like so

# train base and extended models
	# we use the training subset of the data to train our model
mod_1 lm(wage ~ sector + exper, data = Training_data)
mod_2 lm(wage ~ sector + exper + age, data = Training_data)

# calculate model outputs
	# then we use the testing subset of our observed data to test the model we trained with the (non-overlapping) training data
	# the data is 'new' because the model never saw the data when the model was training 
preds_1 <-  predict(mod_1, newdata = Testing_data)
preds_2 <-  predict(mod_2, newdata = Testing_data)

# now we can calculate errors
errors_1 <- Testing_data$wage - preds_1
errors_2 <- Testing_data$wage - preds_2

# Tidying up

# before we get started with cross validating, we need to 'tidy up' our R commands
	# the term 'tidy programming' referes to a style where variables are always kept as part of a data frame and the functions always take a data frame as an input

# model training is intrisically tidy
	# predict() is untidy, sincie it's output is not part of a dataframe

mod <- lm(net ~ age + sex, data = Runners)
out <- predict(mod, newdata = Runners)

	# mean() from base R is also untidy, since you have to use the $ extract the variable from the dataframe

mean((Runners$net - out)^2, na.rm = TRUE)

	# here is an even tidier way to predict and calculate MSE:

out2 <- evaluate_model(mod, data = Runners)
with(data = out2, mean((net - model_output) ^ 2, na.rm = TRUE))

	# evaluate_model() from library("statisticalModeling") creates output out2, which is a dataframe containing both inputs and corresponding outputs, side by side 
		# in otherwords, all your work
	# this will replace the untidy predict() for the remainder of the course
	# with() avoids the need to use the untidy $

# Testing and Training Datasets

# Generate a random TRUE or FALSE for each case in Runners_100
Runners_100$training_cases <- rnorm(nrow(Runners_100)) > 0

# Build base model net ~ age + sex with training cases
	# subset calls all trainging_cases that are TRUE
base_model <- lm(net ~ age + sex, data = subset(Runners_100, training_cases))

# Evaluate the model for the testing cases
	# we call the testing data with the !training_cases
		# now the subset will be based on training_cases that are FALSE
Preds <- evaluate_model(base_model, data = subset(Runners_100, !training_cases))

# Calculate the MSE on the testing data
	# since assignment in training_cases was random, this will give slightly different results each time. later we will see how to rerun this calculation to deal with this randomness
with(data = Preds, mean((net - model_output)^2))


# Repeating Random Trials

# what we did was a cross validation trial. 
	# we call it a trial because it invovles random assignment of cases to the training and testing sets.
	# the result of the calculation was therefore (somewhat) random

# sinse the result of cross validation varies from trial to trial
	# we run many trials so that you can see how much variation there is. 
	# this is a common practice, as we'll see moving forward

# the cv_pred_error() function in library("statisticalModeling") will carry out this repetitive process for you
	# all you need to do is provide one or more input models 

# we want to see if the prediction error calculated from the training data is consistently different from the cross validated prediction error
	# we'll calculate the in sample error using only the training data. 
	# then we'll do the cross validaiton and use a t-test to see if the in-sample error is statistically different from the cross validated error

# The model
model <- lm(net ~ age + sex, data = Runners)

# Find the in-sample error (using the training data)
in_sample <- evaluate_model(model, data = Runners)
in_sample_error <- 
  with(in_sample, mean((net - model_output)^2, na.rm = TRUE))

# Calculate MSE for many different trials
trials <- cv_pred_error(model)
#trials <- cv_pred_error(model, ntrials = 10)

# View the cross-validated prediction errors
trials

# Find confidence interval on trials and compare to training_error
	# the in sample prediction error is usually less than the cross- validated error
mosaic::t.test(~ mse, mu = in_sample_error, data = trials)

# To add or not to add an explanitory variable
	# we're going to use cross valdiation to find out whether adding a new explanatory variable improves the prediction performance of a model
	# remember that models are biased to perform well on the trianing data
	# cross validation gives a fair indication of the prediciton error on the new data

# The base model
base_model <- lm(net ~ age + sex, data = Runners)

# An augmented model adding previous as an explanatory variable
aug_model <- lm(net ~ age + sex + previous, data = Runners)

# Run cross validation trials on the two models
trials <- cv_pred_error(base_model, aug_model)

# Compare the two sets of cross-validated errors
t.test(mse ~ model, data = trials)

