#scoping in R
  #https://campus.datacamp.com/courses/writing-functions-in-r/a-quick-refresher?ex=5

#scoping determines how R looks up values by name
#if assign the value 10 to x and then ask for x
x <- 10
x
#scoping describes the process that R uses to find the value 10

#here the function begins scoping in a new working enviornment
  #within the enviornment, x and y are defined
f <- function(){
  x <- 1 
  y <- 2
  c(x,y)
}
f() #returns function f()

#if a variable referred to inside a function doesn't exist inside a function
  #R will go one level up to find them

#in the following funciton, y is defined, but x is not
  #g() must return x and y, and goes 'up' one level to find a value for x
  #if x wasn't defined at any leve, the function would return an error
x <- 2
g <- function(){
  y <- 1
  c(x,y)
}
g()

#scoping determines where, not when, to look for a value
  #this means that we don't know what f() will return
  #functions shouldn't rely on scoping, as it may affect their robustness
f <-function() x
x <- 15
f() #returns '15'
x <- 20
f() #returns '20'

#this holds the same for calling functions within functions as well
l <- function(x) x + 1
m <- function(){
  l <- function(x) x * 2
  l(10)
}
m()

#each call to a function has its own clean enviornment
  #below is a function that defines a if it is undefined
  #or it defines 'a' as 'a + 1' if it is already defined
  #it will always return '1', because j() will always start with a clean environment
j <- function(){
  if (!exists("a")){
    a <- 1
  } else {
    a <- a + 1
  }
  print(a)
}
j()

#variables defined in a function are not available in the global enviornment

