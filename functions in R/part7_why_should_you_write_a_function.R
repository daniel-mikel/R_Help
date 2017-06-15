#part 7: why should you write a function
#https://campus.datacamp.com/courses/writing-functions-in-r/when-and-how-you-should-write-a-function?ex=1

#I think this is the data they'll use
df <- data.frame(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10))

#what does this code do?
  #same operation for each column
  #the goal is to scale each value to a range of 0 to 1

df$a <- (df$a - min(df$a, na.rm = TRUE)) / 
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))

df$b <- (df$b - min(df$b, na.rm = TRUE)) / 
  (max(df$b, na.rm = TRUE) - min(df$b, na.rm = TRUE))

df$c <- (df$c - min(df$c, na.rm = TRUE)) / 
  (max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE))

df$d <- (df$d - min(df$d, na.rm = TRUE)) / 
  (max(df$d, na.rm = TRUE) - min(df$d, na.rm = TRUE))
#weaknesses to above approach
  #duplication is hiding the intent of our operation
  #also makes it hard to see mistakes

#how to prevent this?
  #rule of thumb: if you copy and paste twice, its time to write a function

#writing a funciton makes the intent clearer
  #easier to read
  #easier to spot mistakes!
  #still some repetition here, we learn to fix this later with library(purr)
df$a <- rescale01(df$a)
df$b <- rescale01(df$b)
df$c <- rescale01(df$c)
df$d <- rescale01(df$d)

# exorcise #
############

#We have a snippet of code that successfully rescales a column to be between 0 and 1
  #we want to make a function rescale01() that we will apply to vectors of the dataframe

# Define example vector x
x <- c(1:10)

# Rewrite this snippet to refer to x
(df$a - min(df$a, na.rm = TRUE)) /
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))

(x - min(x, na.rm = TRUE)) /
  (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))

#there is still duplication with the min(x, na.rm = TRUE)) function
  #rewrite the code to to define the min(x, na.rm = TRUE)) function for brevity

# Define example vector x
x <- 1:10

# Define rng
rng <- range(x, na.rm = TRUE)

# Rewrite this snippet to refer to the elements of rng
(x - rng[1]) /
  (rng[2] - rng[1])

#Finally turn it into a function!

# Define example vector x
x <- 1:10 

# Use the function template to create the rescale01 function
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE) 
  (x - rng[1]) / (rng[2] - rng[1])
}

# Test your function, call rescale01 using the vector x as the argument
rescale01(x)
