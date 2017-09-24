# https://cran.r-project.org/web/packages/ggjoy/vignettes/introduction.html

# ggjoy has been depricated, now ggridges

library(ggplot2)
library(ggridges)
library(gridExtra) 
library(ggjoy)
library(tidyverse)

# geom_ridgeline() can be used to draw lines with a fill underneath
data <- data.frame(x = 1:5, y = rep(1, 5), height = c(0, 1, 3, 4, 2))
ggplot(data, aes(x, y, height = height)) + geom_ridgeline()



# geom_ridgeline() can plot negative values
	# but they need to be specified
	# here the graph to the right is a normal geom_ridgeline() 
		# and on the left includes the minimum point
# library(gridExtra) allows you to plot side by side 
data <- data.frame(x = 1:5, y = rep(1, 5), height = c(0, 1, -1, 3, 2))
plot_base <- ggplot(data, aes(x, y, height = height))
grid.arrange(plot_base + geom_ridgeline(),
          plot_base + geom_ridgeline(min_height = -2), ncol = 2)



# draw multiple ridgelines at the same time
	# the 'group' aestetic must be specified so that geom knows which parts of the data belong to which ridgeline
d <- data.frame(x = rep(1:5, 3), y = c(rep(0, 5), rep(1, 5), rep(2, 5)),
                height = c(0, 1, 3, 4, 0, 1, 2, 3, 5, 4, 0, 5, 4, 4, 1))
ggplot(d, aes(x, y, height = height, group = y)) + geom_ridgeline(fill = "lightblue")



# we can also draw ridgelines with geom_joy()
	# because ggjoy has been depricated:
		# geom_joy() is now geom_density_ridges() 
	# you can still use geom_joy() from library(ggjoy)
		# you'll just get a warning message
ggplot(d, aes(x, y, height = height, group = y)) + 
  geom_density_ridges(stat = "identity", scale = 1)

ggplot(d, aes(x, y, height = height, group = y)) + 
  geom_joy(stat = "identity", scale = 1)



# Density joyplots
  	# the 'height' aesthetic does not need to be specified in this case
ggplot(iris, aes(x = Sepal.Length, y = Species)) + geom_joy()


# geom_joy2() is similar to geom_joy()
	# just uses closed polygons instead of ridgelines for drawing
ggplot(iris, aes(x = Sepal.Length, y = Species)) + geom_joy2()


# the grouping aesthetic does not need to be provided if a catagorical varialbe is being mapped on to the y axis
	# however, if the y axis is numeric, then grouping will need to be specified
iris_num <- transform(iris, Species_num = as.numeric(Species))
ggplot(iris_num, aes(x = Sepal.Length, y = Species_num)) + 
	geom_joy2()  # gives error becasue y is a numeric


ggplot(iris_num, aes(x = Sepal.Length, y = Species_num, group = Species_num)) + geom_joy2()  # this works now, because of the 'group' aesthetic


# trailing tails can be cut off with 'rel_min_height' aethetic
	# a value of 0.01 usually works, but may not depending on the dataset
ggplot(iris, aes(x = Sepal.Length, y = Species)) + geom_joy(rel_min_height = 0.01)


# the extent that different densities overlap is controlled by the 'scale' parameter
	# scale = 1 means that the tallest density curve just touches the baseline of the next tallest curve

# scale = 1 
	# touching
ggplot(iris, aes(x = Sepal.Length, y = Species)) + geom_joy(scale = 1)

# scale = 0.9 
	# no touching
ggplot(iris, aes(x = Sepal.Length, y = Species)) + geom_joy(scale = 0.9)

# scale = 5
	# substantial overlap
ggplot(iris, aes(x = Sepal.Length, y = Species)) + geom_joy(scale = 5)



# scaling is calculated separately per panel
	# we facetwrap by species 
	# now each density plot just touches the next higher baseline
ggplot(iris, aes(x = Sepal.Length, y = Species)) + 
  geom_joy(scale = 1) + facet_wrap(~Species)



# themes

# joyplots require some modifications to look good
  	# the theme_joy() does some theme modifications for you

# no theme_joy()
ggplot(iris, aes(x = Sepal.Length, y = Species)) + geom_joy()

# yes theme_joy()
ggplot(iris, aes(x = Sepal.Length, y = Species)) + geom_joy() + theme_joy()

# theme_joy() in library(ggridges) is theme_ridges()
ggplot(iris, aes(x = Sepal.Length, y = Species)) + geom_joy() + theme_ridges()


# however, there are still a few errors with theme_joy()
	# virginica is slightly cut off from the top
	# space btw. the axis labels and the ridgelines is too large

ggplot(iris, aes(x = Sepal.Length, y = Species)) + 
  geom_joy() + theme_joy() +
  scale_x_continuous(expand = c(0.01, 0)) +
  scale_y_discrete(expand = c(0.01, 0))

# by default, theme_joy() adds a grid
  	# the grid can be switched off

ggplot(iris, aes(x = Sepal.Length, y = Species)) + 
  geom_joy() + theme_joy(grid = FALSE) +
  scale_x_continuous(expand = c(0.01, 0)) +
  scale_y_discrete(expand = c(0.01, 0))


# you can also use theme_minimal
 ggplot(iris, aes(x = Sepal.Length, y = Species)) + 
   geom_joy() + 
   theme_minimal(base_size = 14) + theme(axis.text.y = element_text(vjust = 0)) +
   scale_x_continuous(expand = c(0.01, 0)) +
   scale_y_discrete(expand = c(0.01, 0))  


# Cyclical scales

 # many joyplots improve with an alternating color scheme for the filled area
   # scale_fill_cyclical() cycles through the given colors in the joyplot

ggplot(diamonds, aes(x = price, y = cut, fill = cut)) + 
  geom_joy(scale = 4) + 
  scale_fill_cyclical(values = c("blue", "green"))

# by default, scale_fill_cyclical() will not draw a legend
  # but the legend can be a little buggy
  # may need to manually set legend

# doesn't work:
ggplot(diamonds, aes(x = price, y = cut, fill = cut)) + 
  geom_joy(scale = 4) + 
  scale_fill_cyclical(values = c("blue", "green"), guide = "legend")

# does work
ggplot(diamonds, aes(x = price, y = cut, fill = cut)) + 
  geom_joy(scale = 4) + 
  scale_fill_cyclical(values = c("blue", "green"), guide = "legend",
                      labels = c("Fair" = "blue", "Good" = "green"),
                      name = "Fill colors") 

# you can change the various aesthetics of the plot:
  	# like color, size, alpha, linetype, etc.
ggplot(diamonds, aes(x = price, y = cut, fill = cut, color = cut)) + 
  geom_joy(scale = 4, size = 1) + 
  scale_fill_cyclical(values = c("blue", "green"), guide = "legend",
                      labels = c("Fair" = "blue w/ black outline",
                                 "Good" = "green w/ yellow outline"),
                      name = "Color scheme") +
  scale_color_cyclical(values = c("black", "yellow"), guide = "legend",
                      labels = c("Fair" = "blue w/ black outline",
                                 "Good" = "green w/ yellow outline"),
                      name = "Color scheme")

# cyclical scales are generic ggplot2 scales
  # they work with any geom()

ggplot(mpg, aes(x = class, fill = class, color = class)) + 
  geom_bar(size = 1.5) +
  scale_fill_cyclical(values = c("blue", "green"), guide = "legend",
                      labels = c("blue w/ black outline", "green w/ yellow outline"),
                      name = "Color scheme") +
  scale_color_cyclical(values = c("black", "yellow"), guide = "legend",
                      labels = c("blue w/ black outline", "green w/ yellow outline"),
                      name = "Color scheme") 

mpg %>% group_by(class) %>% tally() %>% arrange(desc(n)) %>%
  mutate(class = factor(class, levels=class)) %>%
  ggplot(aes(x = class, y = n, fill = class)) + 
    geom_col() + theme_minimal() +
    scale_fill_cyclical(values = c("#4040B0", "#9090F0")) +
    scale_y_continuous(expand = c(0, 0))



# Stats

 # the default stat used with geom_joy() is stat_joy()
    # it may not do exactly what you want
    # stat_joy estimates the data range and bandwidth for the density estimation
    	# does this with all the data, not within each of the sets of grouped data
	    # this makes joyplots() look more uniform
    	# but may look different from  geom_density() or stat_density()
    # to fix this, we can use stat_density with geom_joy()
    	# need to put density into the height aesthetic!

ggplot(iris, aes(x = Sepal.Length, y = Species, height = ..density..)) + 
  geom_joy(stat = "density")

# what if we have calculated densities ourselves?
  # call geom_joy(stat = "identity") to tell R to not calculate density scaling

iris %>% group_by(Species) %>%
  do(ggplot2:::compute_density(.$Sepal.Length, NULL)) %>%
  rename(Sepal.Length = x) -> iris_densities
head(iris_densities)

ggplot(iris_densities, aes(x = Sepal.Length, y = Species, height = density)) + 
  geom_joy(stat = "identity")

# if you prefer histograms to density plots

ggplot(iris, aes(x = Sepal.Length, y = Species, height = ..density..)) + 
  geom_joy(stat = "binline", bins = 20, scale = 0.95, draw_baseline = FALSE)