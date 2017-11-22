#ggplot2
 #tutorial from Data Camp


# Part 1

#https://campus.datacamp.com/courses/data-visualization-with-ggplot2-1/chapter-1-introduction-30dbf683-e5ab-4c76-9bbd-3b3afbf15383?ex=1

# Load the ggplot2 package
library(ggplot2)
library(dplyr) # I added for convenience

#we will start with the mtcars dataset
  #contains information on 32 cars from motor trends magazine from 1973
  #dataset is small, intuitive, and has both continuous and catagorical variables

# Explore the mtcars data frame with str()
str(mtcars)

# Execute the following command
ggplot(mtcars, aes(x = cyl, y = mpg)) +
  geom_point()

#the past plot was not so satisfying
  #varialbe 'cyl' is catagorial 

#we'll need to specifically tell ggplot that cyl is a catagorical variable
ggplot(mtcars, aes(x = factor(cyl), y = mpg)) + #here we wrapped factor() around 'cyl'
  geom_point()
  #this gives us a better plot on the x-axis

#graphics are built on an underlying grammer
  #two key ideas
    #graphics are made of distinct layers
    #meaningful plots through aesthetic mapping

#essential grammatical elements
  #data
    #what is being plotted
  #aesthetics
    #the scales onto which we map our data
  #geometries
    #visual elements used for our data

#other (optional) grammatical elements
  #facets
    #plotting small multiples
  #statistics 
    #representations of our data to aid understanding
  #coordinates
    #the space on which the data will be plotted
  #themes
    #all non-data ink

# A scatter plot has been made for you
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point()

# here we can change th color of points, based on the value of the 'disp' variable
ggplot(mtcars, aes(x = wt, y = mpg, col = disp)) +
  geom_point()

# here we change the size of the point to the value of the 'disp' variable
ggplot(mtcars, aes(x = wt, y = mpg, size = disp)) +
  geom_point()

# another element in the aes() argument is the shape of the points
  # there are a finite amount of shapes in ggplot()
  # can't work with continuous data

# we explore the diamonds dataframe
  # contains metrics for 50,000 diamonds
  # here we use two common geom layer functions:
    # geom_point() which tells ggplot() to draw points on the plot
    # geom_smooth() which tells ggplot() will draw a smoothed line over the points

# Explore the diamonds data frame with str()
str(diamonds)

# geom_point()
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point()

# geom_point() +
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_smooth()

# ggplot() allows us to stack layers, here we stack the last two graphs
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point() + 
  geom_smooth()

# this allows us to work with our data pretty freely
  # we can plot the smooth lines for different colors of our data
ggplot(diamonds, aes(x = carat, y = price, col = clarity)) +
  geom_smooth()

# we produce a point plot with slightly transparent points
  # and keep the colors from the smooth function above
ggplot(diamonds, aes(x = carat, y = price, col = clarity)) +
  geom_point(alpha = 0.4)

# understanding the grammer

# Create the object containing the data and aes layers: dia_plot
dia_plot <- ggplot(diamonds, aes(x = carat, y = price)) 

# we can add the geom_point() layer on top of our data and aesthetics layer
  # same as before, but we've saved the layer information in an object in R
dia_plot + geom_point()

# we can also call aes() within the geom_point() function
dia_plot + geom_point(aes(col= clarity))

# Expand dia_plot by adding geom_point() with alpha set to 0.2
dia_plot <- ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point(alpha = 0.2)

# now we want to print that dia_plot, with a geom_smooth() layer on top
  # but this time we don't want the error lines that come with geom_smooth() 
    # we achieve this by adding in the se = FALSE
dia_plot + geom_smooth(se = FALSE)

#same as above but adding the col = clarity argument to aes()
dia_plot + geom_smooth(aes(col = clarity), se = FALSE)

# objects and layers
   # how to understand data

# the ggplot() argument is used for all types of plots in ggplot
  # in contrast to base packages, were each type of plot gets a different argument
  # ggplot() keeps the:
    # data layer
    # aestetic layer

# the ggplot object
  # allows us to easily place diffeerent layers on top of a data and aestetic layer

#now we'll make similar plots with ggplot and base

# Plot the correct variables of mtcars
plot(mtcars$wt, mtcars$mpg) #base package
plot(mtcars$wt, mtcars$mpg, col = mtcars$cyl)

# Change cyl inside mtcars to a factor
mtcars$cyl <- as.factor(mtcars$cyl)

plot(mtcars$wt, mtcars$mpg, col = mtcars$cyl) #same plot as above


# Use lm() to calculate a linear model and save it as carModel
carModel <- lm(mtcars$mpg ~ mtcars$wt, data = mtcars)

# Call abline() with carModel as first argument and set lty to 2
abline(carModel, lty = 2) #the lty argument of 2 makes it a dotted line

# Plot each subset efficiently with lapply
lapply(mtcars$cyl, function(x) {
  abline(lm(mpg ~ wt, mtcars, subset = (cyl == x)), col = x)
  })

# This code will draw the legend of the plot
legend(x = 5, y = 33, legend = levels(mtcars$cyl),
       col = 1:3, pch = 1, bty = "n")


# Convert cyl to factor (don't need to change)
mtcars$cyl <- as.factor(mtcars$cyl)

# Plot from previous section written in one block
plot(mtcars$wt, mtcars$mpg, col = mtcars$cyl)
abline(lm(mpg ~ wt, data = mtcars), lty = 2)
lapply(mtcars$cyl, function(x) {
  abline(lm(mpg ~ wt, mtcars, subset = (cyl == x)), col = x)
  })
legend(x = 5, y = 33, legend = levels(mtcars$cyl),
       col = 1:3, pch = 1, bty = "n")

# Plot 1: add geom_point() to this command to create a scatter plot
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
  geom_point()  # gives us the scatter plot

# Plot 2: include the lines of the linear models, per cyl
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
  geom_point() + 
  geom_smooth(method = lm, se = FALSE)   # adds the lm layer, arguments specify line behaviour 
                             # "method = lm" makes line a linear model
                             # "se = FALSE" turns off the standerd error default feature of geom_smooth()

# Plot 3: include a lm for the entire dataset in its whole
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
  geom_point() + 
  geom_smooth(method = lm, se = FALSE) +
  geom_smooth(aes(group = 1), method = lm, se = FALSE, linetype = 2) #aes(group=1 draws a single linear model through all the points)

# ggplot2 creates an object that we can manipulate
  # we will see this in the next section, were we work with the  iris data set
  #below we have an effective, but not efficient ggplot graph:
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point() +
  geom_point(aes(x = Petal.Length, y = Petal.Width), col = "red")

# to plot this more efficient, we'll need to tidy the data we're working with
  # in the next section we'll work on manipulating our data to make it easier to plot
str(iris)

# it is important to know how to rearrange your data so that plotting functions becomes easier
  # we'll use the package "tidyr" to do this to the "iris" dataset
    # gather() rearranges the data by specifying columns that are catagorical variables 
      # catagorical variables 'gathered' with the - notation
    # seperate() splits up the new key column, which contains the former headers
      # this is done according to the . notation
      # the new column names ""Part" and "Measure" are given in a character vector

# Load the tidyr package
library(tidyr)

# Fill in the ___ to produce to the correct iris.tidy dataset
iris.tidy <- iris %>%
  gather(key, Value, -Species) %>%
  separate(key, c("Part", "Measure"), "\\.")

str(iris.tidy) #looking at the new data

# this new format allows us to write the code for the following plot more gracefully 
ggplot(iris.tidy, aes(x = Species, y = Value, col = Part)) +
  geom_jitter() +
  facet_grid(. ~ Measure)

#we maniputlate iris again to graph the following:
str(iris)
# Add column with unique ids (don't need to change)
iris$Flower <- 1:nrow(iris) #we do this to keep track of each flower that data comes from

# Fill in the ___ to produce to the correct iris.wide dataset
iris.wide <- iris %>%
  gather(key, value, -Species, -Flower) %>%
  separate(key, c("Part", "Measure"), "\\.") %>%
  spread(Measure, value)

ggplot(iris.wide, aes(x = Length, y = Width, col = Part)) +
  geom_jitter() +
  facet_grid(. ~ Species)

# in the next setting we will explore Aestetics
  # Aestetics =/= Attributes!
  # Attributes is what variable is mapped onto something in ggplot
    # not for how it looks!
    # this is important because we will often want to make multivariate plots
  # Aestetics is the plot's x and y axis
    # in the last chart, sepal length is mapped on the x-axis and width on the y-axis

# for example
  # we can change all the dots in to red
    #this is just changing an attirbute of the dot, not the aesthetics
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point(col = "red")
  
  # we could also map the variables species onto the visible aesthetic
    # that's why we made such a big deal about data structure before
    # if you have one variable split over several columns, or multiple variables in one column
      # you may not be able to create the plot you want

ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width,
                 col = Species)) +
  geom_point()

# Map cyl to y
ggplot(mtcars, aes(x = mpg, y = cyl)) +
  geom_point()

# Map cyl to x
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
  geom_point()
# Map cyl to col

ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
  geom_point()

# Change shape and size of the points in the above plot
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
  geom_point(shape = 1, size = 4)

# now that we've practiced building on existing plots, we'll try making some from scratch

# Map cyl to size
ggplot(mtcars, aes(x = wt, y = mpg, size = cyl)) + 
  geom_point()


# Map cyl to alpha
    # alpha is how transparent the object plotted is
ggplot(mtcars, aes(x = wt, y = mpg, alpha = cyl)) + 
  geom_point()


# Map cyl to shape 
ggplot(mtcars, aes(x = wt, y = mpg, shape = cyl)) + 
  geom_point()


# Map cyl to labels
    # scatter plot where the points are labels of the data
ggplot(mtcars, aes(x = wt, y = mpg, label = cyl)) + 
  geom_text()

# Attributes:
  # we can use all aesthetics as attributes
  # in the following sections we're going to explore this

# Define a hexadecimal color
my_color <- "#123456"

# Set the color aesthetic 
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) + 
  geom_point()


# Set the color aesthetic and attribute 
    # notice that adding the "col" argument in geom_point() cancels out the attribute set in ggplot(aes())!
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) + 
  geom_point(col = my_color)


# Set the fill aesthetic and color, size and shape attributes
    # now the outline is my_color and the fill is dictated by "cyl"
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl)) + 
  geom_point(col = my_color, size = 10, shape = 23)


# Expand to draw points with alpha 0.5
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl)) +
  geom_point(alpha = 0.5)

  
# Expand to draw points with shape 24 and color yellow
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl)) +
  geom_point(col = "yellow", shape = 24)


  
# Expand to draw text with label x, color red and size 10
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl)) +
  geom_text( label = "x", col = "red", size = 10)


# Map mpg onto x, qsec onto y and factor(cyl) onto col
ggplot(mtcars, aes(x = mpg, y = qsec, col = factor(cyl))) +
  geom_point()


# Add mapping: factor(am) onto shape
ggplot(mtcars, aes(x = mpg, y = qsec, col = factor(cyl), shape = factor(am))) +
  geom_point()


# Add mapping: (hp/wt) onto size
ggplot(mtcars, aes(x = mpg, y = qsec, col = factor(cyl), shape = factor(am), size = (hp/wt))) +
  geom_point()

# Modifying Aesthetics
  # we've seen how we set the default aestetics in our scatterplot 
    # the part that is wrapped in the ggplot(aes()) argument
  # the most straight forward position is identity
    # where a point is plotted according to the default aestetic
    # we can set this in further arguments in ggplot(), but it's not necissary

ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, col = Species)) + 
  geom_point()

ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, col = Species)) + 
  geom_point(position = "identity") #same as above

# Jitter
  # adds random noise to the axis, since many of our points were overlapping
  # while the points might not be exaclty where they were before, it allows us to see clustored points that had been overlapping
  # this has two advantages
    # it allows us to determine how much random noise should be added
    # it allow us to make use of this grammer throughout our plotting functions, so it remains consistent

posn.j <- position_jitter(width = 0.1)
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, col = Species)) +
  geom_point(position = posn.j)

# each aestetic has an associated scale function which is determined by our type of data (catagorical, discrete)
  #the second part of the function determines what type of data we are working with


# we saw how we can use jittering in scatter plots, but bar graphs have their own issues
  # we will use "stack", "fill", and "dodge"

cyl.am <- ggplot(mtcars, aes(x = factor(cyl), fill = factor(am)))

# The base layer, cyl.am, is available for you
  # Add geom (position = "stack" by default)
cyl.am + 
  geom_bar(position = "stack")


# Fill - show proportion
cyl.am + 
  geom_bar(position = "fill") 

# Dodging - principles of similarity and proximity
cyl.am +
  geom_bar(position = "dodge") 


# Clean up the axes with scale_ functions
    # the colors and labels are made before, stored as an object, and then called in the function later
val = c("#E41A1C", "#377EB8")
lab = c("Manual", "Automatic")
cyl.am +
  geom_bar(position = "dodge") +
  scale_x_discrete("Cylinders") +  
  scale_y_continuous("Number") + 
  scale_fill_manual("Transmission", 
                    values = val,
                    labels = lab) 

# later we'll cover how to make univariate charts with ggplot
  # here we'll expore it a little, with the jitter function

# Add a new column called group
mtcars$group <- 0

# Create jittered plot of mtcars: mpg onto x, group onto y
ggplot(mtcars, aes(x = mpg, y = group)) + 
  geom_jitter() +
  geom_point()

# Change the y aesthetic limits
ggplot(mtcars, aes(x = mpg, y = group)) + 
  geom_jitter() +
  scale_y_continuous(limits = c(-2, 2)) +
  geom_point()

# aestetics best practices
  # how do we know which one to chose?
  # much of it is based on creativity
  # the intution in the following sections is based on the work of Jacques Bertin in "The Semiology of Graphics" (1967) and William Cleveland "Perception of Visual Elements" (1990s)

# form must follow function
  # and that depends on who your audience is
  # you should not be misrepresenting your data!




# Overplortting 1 - Point Shape and Transparency
# Basic scatter plot: wt on x-axis and mpg on y-axis; map cyl to col
ggplot(mtcars, aes(x = wt, y = mpg, color = cyl)) + 
  geom_point(size = 4)


# Hollow circles - an improvement



# Add transparency - very nice


