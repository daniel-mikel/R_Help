# this is a tutorial from 
	# https://campus.datacamp.com/courses/data-visualization-with-ggplot2-1/chapter-4-geometries?ex=2

library("tidyverse")
library("car") # for dataset 'Vocab'
library("RColorBrewer")
library("UsingR") # for dataset 'salmonharvest'

# note that in certain ggplot coloring functions, variables must be a factor instead of a numeric vector
mtcars$cyl <- as.factor(mtcars$cyl)
mtcars$am <- as.factor(mtcars$am)

Vocab$education <- as.factor(Vocab$education)
Vocab$vocabulary <- as.factor(Vocab$vocabulary)

fish.species <- data.frame(1980:1998, as.data.frame(salmonharvest))
names(fish.species) <- c("Year", names(fish.species[2:6]))

# Scatter Plots and Jittering (1)
# Shown in the viewer:
ggplot(mtcars, aes(x = cyl, y = wt)) +
  geom_point()

# Solutions:
# 1 - With geom_jitter()
ggplot(mtcars, aes(x = cyl, y = wt)) +
  geom_jitter()

# 2 - Set width in geom_jitter()
ggplot(mtcars, aes(x = cyl, y = wt)) +
  geom_jitter(width = 0.1)

# 3 - Set position = position_jitter() in geom_point() ()
ggplot(mtcars, aes(x = cyl, y = wt)) +
  geom_point(position = position_jitter(0.1))




# Scatter Plots and Jittering (2)
# Examine the structure of Vocab
str(Vocab)

# Basic scatter plot of vocabulary (y) against education (x). Use geom_point()
ggplot(Vocab, aes(x = education, y = vocabulary)) + 
	geom_point()


# Use geom_jitter() instead of geom_point()
ggplot(Vocab, aes(x = education, y = vocabulary)) + 
	geom_jitter()

# Using the above plotting command, set alpha to a very low 0.2
ggplot(Vocab, aes(x = education, y = vocabulary)) + 
	geom_jitter(alpha = 0.2)

# Using the above plotting command, set the shape to 1
ggplot(Vocab, aes(x = education, y = vocabulary)) + 
	geom_jitter(alpha = 0.2, shape = 1)



# Histograms

# 1 - Make a univariate histogram
ggplot(mtcars, aes(x = mpg)) +
  geom_histogram()

# 2 - Plot 1, plus set binwidth to 1 in the geom layer
ggplot(mtcars, aes(x = mpg)) +
  geom_histogram(binwidth = 1)

# 3 - Plot 2, plus MAP ..density.. to the y aesthetic (i.e. in a second aes() function)
ggplot(mtcars, aes(x = mpg)) +
  geom_histogram(binwidth = 1, aes(y = ..density..))


# 4 - plot 3, plus SET the fill attribute to "#377EB8"
ggplot(mtcars, aes(x = mpg)) +
  geom_histogram(binwidth = 1, fill = "#377EB8", aes(y = ..density..))


 
# Position

# there are three positions arguments in this exercise
  	# stack
  		# place the bars on top of each other, counts are used
  		# this is the default
  	# fill
  		# place the bars on top of each other, but this time use proportions
  	# dodge
  		# place the bars next to each other

# Draw a bar plot of cyl, filled according to am
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar()

# Change the position argument to stack
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar(position = "stack")


# Change the position argument to fill
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar(position = "fill")


# Change the position argument to dodge
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar(position = "dodge")




# Overlapping Bar Plots

# you can use geom_bar(position = position_dodge()) instead of geom_bar(position = "dodge")
  	# lets you specify the amount you want the positions dodge

# 1 - The last plot form the previous exercise
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar(position = "dodge")

# 2 - Define posn_d with position_dodge()
posn_d <- position_dodge(width = 0.2)

# 3 - Change the position argument to posn_d
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar(position = posn_d)

# 4 - Use posn_d as position and adjust alpha to 0.6
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar(position = posn_d, alpha =0.6)



# Overlapping Histograms

# A basic histogram, add coloring defined by cyl
ggplot(mtcars, aes(x = mpg, fill = cyl)) +
  geom_histogram(binwidth = 1)

# Change position to identity
ggplot(mtcars, aes(mpg, fill = cyl)) +
  geom_histogram(binwidth = 1, position = "identity")


# Change geom to freqpoly (position is identity by default)
ggplot(mtcars, aes(mpg, col = cyl)) +
  geom_freqpoly(binwidth = 1, position = "identity")




# Bar Plots with COlor Ramp, Part 1

# Example of how to use a brewed color palette
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar() +
  scale_fill_brewer(palette = "Set1")

# Use str() on Vocab to check out the structure
str(Vocab)

# Plot education on x and vocabulary on fill
# Use the default brewed color palette
	# this thows an error because n > color palette
ggplot(Vocab, aes(x = education, fill = vocabulary)) +
  geom_bar(position = "fill") +
  scale_fill_brewer()



# Bar Plots with Color Ramp, Part 2

# colorRampPalette() creates a function that can be used to later assign to an object
new_col <- colorRampPalette(c("#FFFFFF", "#0000FF"))
new_col(4) # the newly extrapolated colours
munsell::plot_hex(new_col(4)) # Quick and dirty plot


# Final plot of last exercise
ggplot(Vocab, aes(x = education, fill = vocabulary)) +
  geom_bar(position = "fill") +
  scale_fill_brewer()

# Definition of a set of blue colors
blues <- brewer.pal(9, "Blues") # from the RColorBrewer package

# 1 - Make a color range using colorRampPalette() and the set of blues
blue_range <- colorRampPalette(blues)

# 2 - Use blue_range to adjust the color of the bars, use scale_fill_manual()
ggplot(Vocab, aes(x = education, fill = vocabulary)) +
  geom_bar(position = "fill") +
  scale_fill_manual(values = blue_range(11))




# Overlapping histograms (2)

# 1 - Basic histogram plot command
ggplot(mtcars, aes(mpg)) +
  geom_histogram(binwidth = 1)

# 2 - Plot 1, Expand aesthetics: am onto fill
ggplot(mtcars, aes(x = mpg, fill = am)) +
  geom_histogram(binwidth = 1)

# 3 - Plot 2, change position = "dodge"
ggplot(mtcars, aes(x = mpg, fill = am)) +
  geom_histogram(binwidth = 1, position = "dodge")

# 4 - Plot 3, change position = "fill"
ggplot(mtcars, aes(x = mpg, fill = am)) +
  geom_histogram(binwidth = 1, position = "fill")

# 5 - Plot 4, plus change position = "identity" and alpha = 0.4
ggplot(mtcars, aes(x = mpg, fill = am)) +
  geom_histogram(binwidth = 1, position = "identity", alpha = 0.4)

# 6 - Plot 5, plus change mapping: cyl onto fill
ggplot(mtcars, aes(x = mpg, fill = cyl)) +
  geom_histogram(binwidth = 1, position = "identity", alpha = 0.4)




# Line Plots

# Print out head of economics
head(economics)

# Plot unemploy as a function of date using a line plot
ggplot(economics, aes(x = date, y = unemploy)) +
	geom_line()

# Adjust plot to represent the fraction of total population that is unemployed
ggplot(economics, aes(x = date, y = unemploy/pop)) +
	geom_line()




# Periods of Recession

recess <- data.frame(
	as.Date(c("1969-01-01", "1973-11-01", "1980-01-01", "1981-07-01", "1990-07-01", "2001-03-01"), 
		format="%Y-%m-%d"), 
	as.Date(c("1970-11-01", "1975-03-01", "1980-07-01", "1982-11-01", "1991-03-01", "2001-11-01"), 
		format="%Y-%m-%d")
	)

names(recess) <- c("begin", "end")

# Basic line plot
ggplot(economics, aes(x = date, y = unemploy/pop)) +
  geom_line()

# Expand the following command with geom_rect() to draw the recess periods
ggplot(economics, aes(x = date, y = unemploy/pop)) +
  geom_rect(data = recess,
         aes(xmin = begin, xmax = end, ymin = -Inf, ymax = +Inf),
         inherit.aes = FALSE, fill = "red", alpha = 0.2) +
  geom_line()




# Multiple Time Series, Part 1

# gather() has 4 arguments
  	# the original data frame
  	# the name of the key column (Species)
  	# the name of the value column (Capture)
  	# the name of the grouping variable with a minus in front (-Year)

# Check the structure as a starting point
str(fish.species)

# Use gather to go from fish.species to fish.tidy
fish.tidy <- gather(fish.species, Species, Capture, -Year)


# Multiple Time Series Part 2

ggplot(fish.tidy, aes(x = Year, y = Capture, color = Species)) +
geom_line()