# Exploring Data with Models

# This is part four in a datacamp tutorial
	#https://campus.datacamp.com/courses/statistical-modeling-in-r-part-1/exploring-data-with-models?ex=1

# libraries used:
library("mosaicData")
library("statisticalModeling")
library("rpart")

library("NHANES")
library("dplyr")
library("rpart.plot")

# Prediction error for categorical response variables
	# the techniques in the last lesson are appropriate when the response variable is quantitative
	# it is possible to calculate the difference between the models predictions and the observed value
	# how do we measure classifiers?

# The Maximum Error Rate

# the "start_position" variable catagorizes runner enthusiasm
	# the variable is catagorical, with levels like "calm", "eager", "mellow"
	# we want to see if other variables can account for "start_position"

# Build the null model with rpart()
Runners$all_the_same <- 1 # null "explanatory" variable
null_model <- rpart(start_position ~ all_the_same, data = Runners)

# Evaluate the null model on training data
null_model_output <- evaluate_model(null_model, data = Runners, type = "class")

# Calculate the error rate
with(data = null_model_output, mean(start_position != model_output, na.rm = TRUE))

# Generate a random guess...
null_model_output$random_guess <- mosaic::shuffle(Runners$start_position)

# ...and find the error rate
	# note that the random model does not perform as well as the null model
with(data = null_model_output, mean(start_position != random_guess, na.rm = TRUE))


# A Non-Null Model

# in the previous exercise, we cound that the null model performed better than random guessing. 
	# w/ error rates of 58.5% instead of around 66%
	# now we build a model predicting "start_position" on "age" and "sex"

# Train the model
model <- rpart(start_position ~ age + sex, data = Runners, cp = 0.001)

# Get model output with the training data as input
	# since the output will be in the form of class rather than the probablility of a class, we need to set type = "class"
model_output <- evaluate_model(model, data = Runners, type = "class")

# Find the error rate
	# error rate of this model less than null_model
with(data = model_output, mean(start_position != model_output, na.rm = TRUE))


# A Better Model?
	
# previously we compared a null model of start_position to a model using age and sex as explanitory variables. 
	# we didn't use cross validation
		# so calculated error rates are biased to be low
	# now we'll do a simple cross validation test 

# a hint:
	# its often that variables you think should contribute to prediction in fact do not.
	# being able to reliably discern when explantitories variables do not help is a key skill in modeling

# note:
	# the Training_data adn Testing_data were preloaded into the Data Camp workspace

# Train the models 
null_model <- rpart(start_position ~ all_the_same,
                    data = Training_data, cp = 0.001)
model_1 <- rpart(start_position ~ age, 
                 data = Training_data, cp = 0.001)
model_2 <- rpart(start_position ~ age + sex, 
                 data = Training_data, cp = 0.001)

# Find the out-of-sample error rate
null_output <- evaluate_model(null_model, data = Testing_data, type = "class")
model_1_output <- evaluate_model(model_1, data = Testing_data, type = "class")
model_2_output <- evaluate_model(model_2, data = Testing_data, type = "class")

# Calculate the error rates
null_rate <- with(data = null_output, 
                  mean(start_position != model_output, na.rm = TRUE))
model_1_rate <- with(data = model_1_output, 
                  mean(start_position != model_output, na.rm = TRUE))
model_2_rate <- with(data = model_2_output, 
                  mean(start_position != model_output, na.rm = TRUE))

# Display the error rates
null_rate
model_1_rate
model_2_rate


# Exploring data for relationships

# we can use rpart to form trees of data
model <- rpart(net ~ age + sex, data = Runners, cp = 0.001)
prp(model, type = 1)

# the "cp = 0.001" sets how 'deep' the rpart model will go to explore the relationships of the model
# prp() graphs the model
	# the "type = 3" argument is the style of the chart
		# can choose 1 through 4
	# prp() can graph continues varables (but I'm not sure if it should be used for it, but it can)
	# to use prp(), the object in the model must have beeen an rpart() object 
		# i.e. you couldn't use an lm() model

# Exploring birth weight data

# the Birth_weight dataframes comes from a study of the ris factors of being underweight at birth

# one way of exploring data is by building models with explanitory variables that you think are important
	# but this can be more of a confirmation rather than an exploration

# for instance, consider the two models below
	# the first involves explanitory variables that relate to social or lifestyle choices
	# the second involves biological variables

model_1 <- rpart(baby_wt ~ smoke + income, data = Birth_weight, cp = 0.0001)
model_2 <- rpart(baby_wt ~ mother_age + mother_wt, data = Birth_weight, cp = 0.001)

prp(model_1, type = 3)
prp(model_2, type = 3)

# Smoking is associated with baby_wt, but only for low-income mothers
	# doesn't seem to be an effect
model_si <- rpart(baby_wt ~ smoke + income, data = Birth_weight, cp = 0.0001)
prp(model_si, type = 3)

# Smoking matters for higher-weight smokers
	# smoking seems to matter more for low weight mothers
model_si <- rpart(baby_wt ~ smoke + mother_wt, data = Birth_weight, cp = 0.001)
prp(model_si, type = 3)

# income matters only for non-smokers
	# no effect
model_si <- rpart(baby_wt ~ smoke + income, data = Birth_weight, cp = 0.001)
prp(model_si, type = 3)

# income matters for higher_weight smokers
	# seems least wrong of the three 
model_si <- rpart(baby_wt ~ smoke + income + mother_wt, data = Birth_weight, cp = 0.01)
prp(model_si, type = 3)


# Exploring More Broadly
	# sometimes it makes sense to roll the dice and see what comes up
	# only rpart() architecture provides an oppertunity to automatically choose a subset of the explanitory variables

# we'll train a recursive partitioning model with the formula:
	# baby_wt ~ .
		# the "." is shorthand for using all the other variables in the data
	# rpart() will partition the cases using the single most effective explanatory variable
		# then use the same logic to subdivide groups
		# that's what 'recursive' means: to go through the process of building a model for each subgroup

model <- rpart(baby_wt ~ ., data = Birth_weight, cp = 0.01)
prp(model, type = 3)