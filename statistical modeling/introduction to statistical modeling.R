#Introduction to Statistical Modeling

# tutorial from 
	#https://campus.datacamp.com/courses/statistical-modeling-in-r-part-1/what-is-statistical-modeling?ex=1

# a statistical model is a way to summarize data
	# can be a way to transition from observed data to conclusions

# whats the difference between statistics and modeling
	# a model is a representation for a purpose
	# we build models because they are easier to work with than the real thing

# a statistical model is a special kind of mathmatical model
	# often used to test hypothoses about how something works

# typical objects we will encounter are:
	# functions
		# will generally take both a dataframe and a formula 
	# formulas
		# sets up the structure of the relationship, does not perform arithmatic
		# e.g. wage ~ exper + sector
	# dataframes

library(mosaic)

# in the base package mean() is not meant to work with formulas
	# in library(mosaic) it is upgraded, while still being able to perform its previous functions
mean(wage ~ sector, data = CPS85)

# above the formula mean(wage ~ sector) means to give the average wage broken down by sector

# statistical models are often meant to predict or account for a single variable
	# we call this the response variable
		# always to the left of the ~
	# the functions inputs are called the explanitory variables
		# always to the right of  the ~

# you can think of formulas as a sentance that relates the response and explanitory variables

# so wage ~ sector can be read as any of the following:
	# wage as a function of sector
	# wage accounted for by sector
	# wage modeled by sector
	# wage explained by sector
	# wage given sector
	# wage broken down by sector

# we'll use a custom package for data in this course
library("statisticalModeling")

# Use data() to load Trucking_jobs
data("Trucking_jobs", package = "statisticalModeling")

# View the number rows in Trucking_jobs
	# we can use the mosaicData::CPS85 to refer to the dataseet within the package
nrow(statisticalModeling::Trucking_jobs)

# Use names() to find variable names in mosaicData::Riders
names(mosaicData::Riders)

# Load ggplot2 package
library(ggplot2)

# Look at the head() of diamonds
head(ggplot2::diamonds)

# working with formulas #
#########################

# Find the variable names in AARP
names(statisticalModeling::AARP)

# Find the mean cost broken down by sex
mosaic::mean(Cost ~ Sex, data = AARP)

# graphics with  formulas #
###########################

# Create a boxplot using base, lattice, or ggplot2
boxplot(Cost ~ Sex, data = AARP)

# Make a scatterplot using base, lattice, or ggplot2
plot(Cost ~ Age, data = AARP)