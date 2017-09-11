# these are notes to a datacamp course
	# https://campus.datacamp.com/courses/multiple-and-logistic-regression/parallel-slopes?ex=2

# packages
library("openintro")
library("dplyr")
library("brew")
library("ggplot2")
library("broom")

# the course refers to the dataset in library("openintro") as mario_kart
	# they also filter out two outliers from the dataset

mario_kart <- marioKart %>%
	filter(totalPr <= 100)

# Parallel Slopes Models
	# models in which one explanitory variable is numeric, and another is catagorical
	# Parallel Slopes model have a numeric dependent variable

# Explore the data
glimpse(mario_kart)

# fit parallel slopes
mod <- lm(totalPr ~ wheels + cond, data = mario_kart)


# scatterplot, with color
data_space <- ggplot(augment(mod), aes(x = wheels, y = totalPr, color = cond)) + 
  geom_point()
  
# single call to geom_line()
data_space + 
  geom_line(aes(y = .fitted))

 