#########
# ggvis #
#########

#this is based on a tutorial from datacamp
  #https://campus.datacamp.com/courses/ggvis-data-visualization-r-tutorial/chapter-one-the-grammar-of-graphics?ex=2

#ggvis is based on the grammer of graphics
  #maintained by hadley 

install.packages("ggvis")
library(ggvis)

#ggvis helps us visualize data sets

#the code below visualizes the mtcars data frame that come with R
  #it plots the wt (weight) varable on the x-axis
  #and the mpg (miles per gallon) on the y-axis

mtcars #the dataset

mtcars %>% ggvis(~wt, ~mpg) %>% layer_points()

#we can change the above code to have the disp variable on the x-axis
mtcars %>% ggvis(~disp, ~mpg) %>% layer_points()

##############################
# ggvis and its capabilities #
##############################

#ggvis code is meant to be pretty intuitive
