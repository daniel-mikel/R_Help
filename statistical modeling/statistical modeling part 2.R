
# Designing, Training, and Evaluating Models

# This is part two in a datacamp tutorial
	#https://campus.datacamp.com/courses/statistical-modeling-in-r-part-1/designing-training-and-evaluating-models?ex=1

# libraries used:
library("mosaicData")
library("statisticalModeling")
library("rpart")

# Designing and Training Models 

# the modeling process
	# start with your own ideas about how you think the system works
	# designing, training, and interpreting a model
	# use your data both to train your model and evaluate it

# setting response and explanitory variables
	# which variables are set to response and explanitory depend on what you want your model to accomplish
	# need to select a model architecture
		# common one is the linear model: lm()
		# recrusive partitioning: rpart()

# training a model
	# automatic process carried out by the computer
	# tailors (i.e. "fits") the model to the data


# modeling wage and education
	# we use data form 1985 of 534 workers
library("mosaicData")
head(CPS85)

# we chose wage as a response variable
	# we choose education and experience as explanatory variables
	# since our main interest is in education's effect on wages, experience would be called a "covariate"
		# but as far as the model is concerned, a covariate is just as important of an explanitory variable

model1 <- lm(wage ~ educ + exper, data = CPS85)
model2 <- rpart(wage ~ educ + exper, data = CPS85)

# Model Running Times

# in this exorcise we want to construct a model for runners handicaps
	# data comes from records from the Cherry Blossom Ten Mile Run
	# want to construct models adjusting fro age and sex

library("statisticalModeling")
nrow(Runners)

# Find the variable names in Runners 
names(Runners)

# Build models: handicap_model_1, handicap_model_2, handicap_model_3 
handicap_model_1 <- lm(net ~ age, data = Runners)
handicap_model_2 <- lm(net ~ sex, data = Runners)
handicap_model_3 <- lm(net ~ age + sex, data = Runners)

# For now, here's a way to visualize the models
fmodel(handicap_model_1)
fmodel(handicap_model_2)
fmodel(handicap_model_3)

# Using the Recursive Partitioning Model Architecture

# in the last exercise we used a linear model architecture
	# now we'll use the recursive partitioning model

# Load rpart
library("rpart")

# Build rpart model: model_2
model_2 <- rpart(net ~ age + sex, data = Runners, cp = 0.002)

# Examine graph of model_2 (don't change)
fmodel(model_2, ~ age + sex)

# Will They Run Again?

# previusly we build models of net running time with the intention of constructing a handicap system. 
	# this generated "expected run times", which became the handicap

# now we want to create a model to see if a person will run in a race again
	# this is different than past models, as now the output of this model will be TRUE or FALSE, indicating if the person will participate next year
	# since the response will be catagorical and not numeric, and lm() is intended for linear models
		# we will use rpart()
	# I CAN'T FIND THE DATA USED IN THIS EXERCISE, NEED TO FIND THE DATAFRAME Ran_twice, THE FOLLOWING CODE WON'T WORK!!!

# Create run_again_model
run_again_model <- rpart(runs_again ~ age + sex + net, data = Ran_twice, cp = 0.005)

# Visualize the model (don't change)
fmodel(run_again_model, ~ age + net, data = Ran_twice)

# Evaluating Models
	# provide inputs for explanitory variable(s)
	# calculating a corresponding output
	# we use predict() to get a model output given our input

# the tradtional function for evaluating a model is predict() which takes as arguments the model and newdata
	# newdata gets the dataframe containing the desired inputs
	# a supplimental video is here:
		# https://campus.datacamp.com/courses/introduction-to-statistical-modeling-sidebars/sidebar-videos?ex=5
# library(statisticalModeling) package provides an alternative to predict()
	# evaluate_model()

# Display the variable names in the AARP data frame
names(AARP)

# Build a model: insurance_cost_model
insurance_cost_model <- lm(Cost ~ Age + Sex + Coverage, data = AARP)

# Construct a data frame: example_vals 
example_vals <- data.frame(Age = 60, Sex = "F", Coverage = 200)

# Predict insurance cost using predict()
predict(insurance_cost_model, newdata = example_vals)

# Load statisticalModeling
library("statisticalModeling")

# Calculate model output using evaluate_model()
evaluate_model(insurance_cost_model, data = example_vals)

#Extrapolation

# one sue of modeling is extrapolation, which is finding the model output for inputs that are outside the range on the data
	# in the following section we'll extrapolate the AARP data for people with ages 90 and 30

 range(AARP$Age) # current range of data

# Build a model: insurance_cost_model
insurance_cost_model <- lm(Cost ~ Age + Sex + Coverage, data = AARP)

# Create a data frame: new_inputs_1
new_inputs_1 <- data.frame(Age = c(30, 90), Sex = c("F", "M"), Coverage = c(0, 100))

# Use expand.grid(): new_inputs_2
	# expand.grid() creates a tree of all possiblities, in contrast to above
new_inputs_2 <- expand.grid(Age = c(30, 90), Sex = c("F", "M"), Coverage = c(0, 100))

# Use predict() for new_inputs_1 and new_inputs_2
predict(insurance_cost_model, newdata = new_inputs_1)
predict(insurance_cost_model, newdata = new_inputs_2)

# Use evaluate_model() for new_inputs_1 and new_inputs_2
	# evaluate_model() is the clear winner here, coupled with the expand.grid() function
	# note some of the responses here are below 0, coverage can't be below 0, so beware of extrapolation!
evaluate_model(insurance_cost_model, data = new_inputs_1)
evaluate_model(insurance_cost_model, data = new_inputs_2)


# Typical Values of data
	# sometimes you want to quickly view the typical values that would result from a model
	# if you use the evalueate_model() function without the data argument it will tabulate some data from which the data was trained to show some typical inputs
	# if you prefer a graphical display, fmodel can serve the same purpose
		# note: its typical to plot a qualitative variable on the x-axis and and other explanitory variables as color facets
		# note: catagorical variables look good in facets of charts

# Evaluate insurance_cost_model
evaluate_model(insurance_cost_model)

# Use fmodel() to reproduce the graphic
	# fmodel(model_object, ~ x_var + color_var + facet_var)
fmodel(insurance_cost_model, ~ Coverage + Age + Sex)

# A new formula to highlight difference in sexes
new_formula <- ~ Age + Sex + Coverage

# Make the new plot (don't change)
fmodel(insurance_cost_model, new_formula)

