#writing functions in R
  #https://www.datacamp.com/courses/writing-functions-in-r

#basic recipe for creating a function
my_fun <- function(arg1, arg2){
  body
}

#function() creates a new function
#the arguments to the function are specified in the parentasis
#the body is in curly bracelet, and is run every time the function is called
#we store the output using the <- assignment operator 

add <- function(x , y){
  x + y
}

add(5,3)

#here y is given the default value of 1, if it is not specified
add <- function(x , y = 1){ 
  x + y
}
add(5,3)
add(5)

#we can ask R to display the parts of our function like so
formals(add)
body(add)
environment(add)

#the environment is usually invisible
  #determines where the function will look for variables

#functions return the last evaluated expression
f <- function(x){
  if (x<0){
    -x
  } else {
    x
  }
}
f(-5)
f(15)

#the return function
  #this is recommended when you want to stop execution early and return a value
    #good for special cases rather than routinly

#functions in R work just like any other objects
mean2 <- mean #mean2 now does the same as mean
mean2(1:10) 

#anonymous functions
  #don't have a name
  #still callable, but has to be done on the same line
function(x){x+1}
(function(x){x+1})(2)

############
# exercise #
############


#writing functions

# Define ratio() function
ratio <- function(x, y) {
  x / y
}

# Call ratio() with arguments 3 and 4
ratio(3,4)