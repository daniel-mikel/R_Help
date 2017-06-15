#part 8 how you should write a function
#https://campus.datacamp.com/courses/writing-functions-in-r/when-and-how-you-should-write-a-function?ex=5

#in the last lesson we
  #did not start by filling out a function template
  #we started with a simple problem that we knew how to solve
    #using dummy data is a good idea
  #we wrote a snippit to describe the operation (w/o function)
    #then rename
  #then we remove duplicaiton in the snippit
  #then we write it into a function
  #remember that all your temporary variables become arguments!
  #test your sample data on the function!
    #maybe test it on more complicated data

#let's tackle a new problem. 
  #We want to write a function:
    #both_na() that counts at how many positions two vectors, x and y, both have a missing value. 
    #How do we get started? Should we start writing our function?
both_na <- function(x, y) {
  # something goes here?
}

#No! We should start by solving a simple example problem first. 
# Define example vectors x and y
x <- c( 1, 2, NA, 3, NA)
y <- c(NA, 3, NA, 3,  4)

# Count how many elements are missing in both x and y
sum(is.na(x) & is.na(y))

#now we rewrite above as a function
# Define example vectors x and y
x <- c( 1, 2, NA, 3, NA)
y <- c(NA, 3, NA, 3,  4)

# Turn this snippet into a function: both_na()
both_na <- function(x, y){
  sum(is.na(x) & is.na(y))
}

#we now have a function that works in one situation
  #we should test it in other situations
  #here we try it on vectors with different lengths

# Define x, y1 and y2
x <-  c(NA, NA, NA)
y1 <- c( 1, NA, NA)
y2 <- c( 1, NA, NA, NA)

# Call both_na on x, y1
both_na(x, y1)

# Call both_na on x, y2
both_na(x, y2)

