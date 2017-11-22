# this is a tutorial from 
	# https://campus.datacamp.com/courses/data-visualization-with-ggplot2-1/chapter-3-aesthetics?ex=13

library("tidyverse")


# Overplotting 1 - Point Shape and Transparency

# overplotting common when
	# you have a large dataset
	# impresice data where points are not clearly seperated
	# interval data (data at fixed values i.e. integers)
	# alighned data values on a single axis

# Basic scatter plot: wt on x-axis and mpg on y-axis; map cyl to col
mtcars$cyl <- as.factor(mtcars$cyl)

ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
  geom_point(size = 4)


# Hollow circles - an improvement
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
  geom_point(size = 4, shape = 1)


# Add transparency - very nice
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
  geom_point(size = 4, alpha = 0.6)



# Overplotting 2 - Alpha with Large Datasets
# Scatter plot: carat (x), price (y), clarity (color)
ggplot(diamonds, aes(x = carat, y = price, color = clarity)) +
	geom_point()


# Adjust for overplotting
ggplot(diamonds, aes(x = carat, y = price, color = clarity)) +
	geom_point(alpha = 0.5)


# Scatter plot: clarity (x), carat (y), price (color)
ggplot(diamonds, aes(x = clarity, y = carat, color = price)) +
	geom_point(alpha = 0.5)


# Dot plot with jittering
ggplot(diamonds, aes(x = clarity, y = carat, color = price)) +
	geom_point(alpha = 0.5, position = "jitter")

