# Exploring Data with Models

# This is part five in a datacamp tutorial
	#https://campus.datacamp.com/courses/statistical-modeling-in-r-part-1/covariates-and-effect-size?ex=1
# libraries used:
library("mosaicData")
library("statisticalModeling")
library("rpart")

library("NHANES")
library("dplyr")
library("rpart.plot")

# Covariates

# in the last chapter we looked at explanitory variables in order to serve a particular purpose.

# some uses for models
	# making predictions with availble data
	# exploring a large, complex data set
	# anticipate outcome of intervention in system

# explanitory variables that are not themselves of interest to the modeler, but may shape the response variable

# House Prices

# we have a dataset provided from library("statisticalModeling")
str(Houses_for_sale)

# a newcommer might start with a model like
	# price ~ fireplaces
	# we'll start there

# Train the model price ~ fireplaces
simple_model <- lm(price ~ fireplaces, data = Houses_for_sale)

# Evaluate simple_model
evaluate_model(simple_model)

# Calculate the difference in model price
naive_worth <- 238522.7 - 171823.9

# Train another model including living_area
sophisticated_model <-lm(price ~ fireplaces + living_area, data = Houses_for_sale)

# Evaluate that model
evaluate_model(sophisticated_model)

# Find price difference for fixed living_area
sophisticated_worth <- 242319.5 - 233357.1


# Crime and Poverty

# the dataframe Crime gives some FBI statistics on crime in various US states in 1960
	# R gives the crime rate in each state
	# X gices the number of families with low income
	# W gives the average assets of families in the state
str(Crime)

# Train model_1 and model_2
model_1 <- lm(R ~ X, data = Crime)
model_2 <- lm(R ~ W, data = Crime)

# Evaluate each model...
evaluate_model(model_1)
evaluate_model(model_2)

# ...and calculate the difference in output for each
	#Copy and paste values from the evaluate_model() output to calculate for each model the change in crime rate from the first level of the explanatory variable to the second level (i.e. X = 100 to X = 200 and W = 400 to W = 600)
change_with_X <- 106.82223 - 89.46721
change_with_W <- 103.70777 - 139.08644

# Train model_3 using both X and W as explanatory variables
model_3 <- lm(R ~ X + W, data = Crime)

# Evaluate model_3
evaluate_model(model_3)

# Find the difference in output for each of X and W
	# output to calculate the change in crime rate associated with a decrease of 100 (from 300 to 200) in X, holding W constant at 600
	#  the change in crime rate associated with a decrease of 200 (from 600 to 400) in W, holding X constant at 200.
change_with_X_holding_W_constant <- 228.50366 - 134.86434
change_with_W_holding_X_constant <- 134.86434 - 31.03422


# Equal Pay?

# Train the five models
model_1 <- lm(earnings ~ sex, data = Trucking_jobs)
model_2 <- lm(earnings ~ sex + age, data = Trucking_jobs)
model_3 <- lm(earnings ~ sex + hiredyears, data = Trucking_jobs)
model_4 <- lm(earnings ~ sex + title, data = Trucking_jobs)
model_5 <- lm(earnings ~ sex + age + hiredyears + title, data = Trucking_jobs)

# Evaluate each model...
evaluate_model(model_1)
evaluate_model(model_2, age = 34)
evaluate_model(model_3, hiredyears = 3)
evaluate_model(model_4, title = "PROGRAMMER")
evaluate_model(model_5, age = 34, hiredyears = 3, title = "PROGRAMMER")

# ...and calculate the gender difference in earnings 
diff_1 <- 40236.35 - 35501.25
diff_2 <- 37514.13 - 35159.81
diff_3 <- 38665.17 - 35035.13 
diff_4 <- 41616.92 - 41949.25
diff5_ <- 39746.38 - 39761.66


# Effect Size

# how does the input of a model effect the models output
	# this is called the effect size

# natural units for effect sizes
	# quatitative inputs and outputs have natural units
		# wages measured in $/hr
		# education in years of schooling

# when the effect size is quantitative 
	# effect size represented as a rate
	# change in response / change in input

# when effect size for a catagorical input
	# effect size as a difference


# Sex and Death
	# using the AARP dataset in library("statisticalModeling")
	# find the effect size of Age, Sex, and Coverage on life insurance cost

# train a linear model
life.insurance <- lm(Cost ~ Age + Sex + Coverage, data  = AARP)

# use evaluate_model() to see the model output of several values of the inputs
evaluate_model(life.insurance)

# use effect_size() to measure how a change in the input value changes the output
	# do this for Age, Sex, and Coverage
	# I added the scatterplot to illistrate for my own usage

with(AARP, plot(Age, Cost))
effect_size(life.insurance, Cost ~ Age)

ggplot(AARP, aes(x = Age, y = Cost, col = Coverage)) +
  geom_jitter() +
  facet_grid(. ~ Sex)
effect_size(life.insurance, Cost ~ Sex)

with(AARP, plot(Coverage, Cost))
effect_size(life.insurance, Cost ~ Coverage)


# How do GPAs compare?
	# we use the College_grades data frame from library(statisticalModeling)
str(College_grades)
College_grades %>% filter(sid == "S32250")

# Calculating the GPA 
gpa_mod_1 <- lm(gradepoint ~ sid, data = College_grades)

# The GPA for two students
evaluate_model(gpa_mod_1, sid = c("S32115", "S32262"))

# Use effect_size()
	# compares two levels of inputs
effect_size(gpa_mod_1, ~ sid)

# Specify from and to levels to compare
effect_size(gpa_mod_1, ~ sid, sid = "S32115", to = "S32262")

# A better model?
	# create a model that controls for:	
		# "dept" or the department that the course was in
		# "level" or the level of the course

gpa_mod_2 <- lm(gradepoint ~ sid + dept + level, data = College_grades)

# Find difference between the same two students as before
effect_size(gpa_mod_2, ~ sid, sid = "S32115", to = "S32262")


# Houseing Units
	# variables often have units
	# in Houses_for_sale
		# price is in dollars
		# land_value is in dollars
		# living_area is in square feet
		# fireplaces is a pure number
	# for quantitative explanatory variables, effect size always have the unit of the response variable divided by the unit of the explanatory variable

lm(price ~ living_area + land_value + fireplaces, data = Houses_for_sale)