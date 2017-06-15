#Arguments
  #https://campus.datacamp.com/courses/writing-functions-in-r/a-quick-refresher?ex=3

#part 3

#recall the previous function:
ratio <- function(x, y) {
  x / y
}

#we can use the function either with
ratio(3,4) #relies on matching by position
ratio(x=3,y=4) #relies on matching by name

#positional matching is good for the first 1 or 2 arguments
  #also the x and y arguments for plotting functions

#matching arguments are good for
  #optional arguments
  #when overriding a default value

#best practices for writing
  #when you call a function, put a space around the "="
  #always put a space after the comma
  #using whitespace makes it much easier to skim function for important components!

# Rewrite the call to follow best practices
mean(0.1, x = c(1:9, NA), TRUE)
mean(c(1:9, NA), trim = 0.1, na.rm = TRUE)

