# this is a tutorial from datacamp's ggplot2 part 2
	# https://campus.datacamp.com/courses/data-visualization-with-ggplot2-2/chapter-1-statistics?ex=1

library("tidyverse")
library("car") # for dataset 'Vocab'
library("RColorBrewer")

# clean the data before exorcises

mtcars$cyl <- as.factor(mtcars$cyl)
mtcars$am <- as.factor(mtcars$am) 

mamsleep <- msleep %>%
	gather(sleep, time, -c(name, vore)) %>%
	filter(sleep %in% c("sleep_total", "sleep_rem"))

mamsleep$sleep <- gsub("sleep_", "", mamsleep$sleep)

anti_names <- mamsleep %>% 
	filter(is.na(time)) %>%
	select(name)

mamsleep <- mamsleep %>%
	anti_join(anti_names) %>%
	arrange(name)

# Zooming In

# Basic ggplot() command, coded for you
p <- ggplot(mtcars, aes(x = wt, y = hp, col = am)) + geom_point() + geom_smooth()

# Add scale_x_continuous
	# drops geom_smooth()
p + scale_x_continuous(limits = c(3,6), expand = c(0,0))

# The proper way to zoom in:
	# does not drop geom_smooth()
p + coord_cartesian(xlim = c(3,6))




# Aspect Ratio
	# given that both the units in the graph below are in cm, it would be illistrative to plot both variables with the same ratios 
	# 


# Complete basic scatter plot function
base.plot <- ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, col = Species)) +
               geom_jitter() +
               geom_smooth(method = "lm", se = F)

# Plot base.plot: default aspect ratio
base.plot

# Fix aspect ratio (1:1) of base.plot
base.plot + coord_equal()




# Pie Charts

# Create stacked bar plot: thin.bar
thin.bar <- ggplot(mtcars, aes(x = 1, fill = cyl)) +
              geom_bar()

# Convert thin.bar to pie chart
   # using just coord_polar() makes a target shapped plot
      # including theta = "y" argument creates the bar chart
thin.bar + coord_polar(theta = "y")

# Create stacked bar plot: wide.bar
wide.bar <- ggplot(mtcars, aes(x = 1, fill = cyl)) +
              geom_bar(width = 1)

# Convert wide.bar to pie chart
wide.bar + coord_polar(theta = "y")




# Facets Layer

# Facets: the basics

# Basic scatter plot:
p <- ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point()

# Separate rows according to transmission type, am
p + facet_grid(am ~ .)

# Separate columns according to cylinders, cyl
p + facet_grid(. ~ cyl)

# Separate by both columns and rows 
p + facet_grid(am ~ cyl)



#  Many Variables

# Code to create the cyl_am col and myCol vector
mtcars$cyl_am <- paste(mtcars$cyl, mtcars$am, sep = "_")
myCol <- rbind(brewer.pal(9, "Blues")[c(3,6,8)],
               brewer.pal(9, "Reds")[c(3,6,8)])

# Basic scatter plot, add color scale:
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl_am)) +
  geom_point() +
  scale_color_manual(values = myCol)

  
# Facet according on rows and columns.
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl_am)) +
  geom_point() +
  scale_color_manual(values = myCol) +
  facet_grid(gear ~ vs)

# Add more variables
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl_am, size = disp)) +
  geom_point() +
  scale_color_manual(values = myCol) +
  facet_grid(gear ~ vs)



# Dropping Levels

# Basic scatter plot
ggplot(mamsleep, aes(x = time, y = name, col = sleep)) +
	geom_point()

# Facet rows accoding to vore
		# notice that there is a lot of extra lines on the y axis
ggplot(mamsleep, aes(x = time, y = name, col = sleep)) +
	geom_point() +
	facet_grid(vore ~ .)

# Specify scale and space arguments to free up rows
ggplot(mamsleep, aes(x = time, y = name, col = sleep)) +
	geom_point() +
	facet_grid(vore ~ ., scale = "free_y", space = "free_y")