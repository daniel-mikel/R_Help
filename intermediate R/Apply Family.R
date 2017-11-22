
# these are notes from a datacamp course
	# https://campus.datacamp.com/courses/intermediate-r/chapter-4-the-apply-family?ex=2

# I didn't take notes on some of the other units in the course
	# most of it was review



# Use lapply() with build in R function


# The vector pioneers has already been created for you
pioneers <- c("GAUSS:1777", "BAYES:1702", "PASCAL:1623", "PEARSON:1857")

# Split names from birth year
split_math <- strsplit(pioneers, split = ":")

# Convert to lowercase strings: split_low
split_low <- lapply(split_math, tolower)

# Take a look at the structure of split_low
str(split_low)



# Use lapply With Your Own Functions
	# you can pass any function availavle in the workspace through apply()

# Code from previous exercise:
pioneers <- c("GAUSS:1777", "BAYES:1702", "PASCAL:1623", "PEARSON:1857")
split <- strsplit(pioneers, split = ":")
split_low <- lapply(split, tolower)

# Write function select_first()
select_first <- function(x) {
  x[1]
}

# Apply select_first() over split_low: names
names <- lapply(split_low, select_first)

# Write function select_second()
select_second <- function(x) {
  x[2]
}

# Apply select_second() over split_low: years
years <- lapply(split_low, select_second)



# lapply() and anonymous functions
	# you can also define a function inside an apply() function
	# this way you don't need to create it in the global enviornment to only use it once.

# this code does the same as in the above section
	# except the functions are definied within the apply() function

# Definition of split_low
pioneers <- c("GAUSS:1777", "BAYES:1702", "PASCAL:1623", "PEARSON:1857")
split <- strsplit(pioneers, split = ":")
split_low <- lapply(split, tolower)

# Transform: use anonymous function inside lapply
names <- lapply(split_low, function(x) {
  x[1]
})

# Transform: use anonymous function inside lapply
years <- lapply(split_low, function(x) {
  x[2]
})




# lapply() can handle functions with multiple arguments

# Definition of split_low
pioneers <- c("GAUSS:1777", "BAYES:1702", "PASCAL:1623", "PEARSON:1857")
split <- strsplit(pioneers, split = ":")
split_low <- lapply(split, tolower)

# Generic select function
select_el <- function(x, index) {
  x[index]
}

# Use lapply() twice on split_low: names and years
names <- lapply(split_low, select_el, 1)
years <- lapply(split_low, select_el, 2)



# how to use sapply()
	# will return results as a vector
	# if R cannot simplify returned information, will return a list like lapply()

temp <- list(c(3,7,9,6,-1),
			 c(6,9,12,13,15),
			 c(4,8,3,-1,-3),
			 c(1,4,7,2,-2),
			 c(5,7,9,4,2),
			 c(-3,5,8,9,4),
			 c(3,6,9,4,1))

# Use lapply() to find each day's minimum temperature
lapply(temp, min)

# Use sapply() to find each day's minimum temperature
sapply(temp, min)

# Use lapply() to find each day's maximum temperature
lapply(temp, max)

# Use sapply() to find each day's maximum temperature
sapply(temp, max)



# sapply() with your own function

# Finish function definition of extremes_avg
extremes_avg <- function(x) {
  ( min(x) + max(x) ) / 2
}

# Apply extremes_avg() over temp using sapply()
sapply(temp, extremes_avg)

# Apply extremes_avg() over temp using lapply()
lapply(temp, extremes_avg)



# sapply() with funciton returning vector

# Create a function that returns min and max of a vector: extremes
extremes <- function(x) {
  c(min = min(x), max = max(x))
}

# Apply extremes() over temp with sapply()
sapply(temp, extremes)

# Apply extremes() over temp with lapply()
lapply(temp, extremes)



# vapply()
	# similar to lapply() and sapply()
	# where:
		# lapply() returns a list
		# sapply() returns a vector if possible or lists
		# vapply() lets you specify the returned class
			# if R is unable to return result in your given class, it returns an error message instead of a list (this makes it unlike sapply())
	#  vapply(x, FUN, FUN.VALUE, ...)

# Definition of basics()
basics <- function(x) {
  c(min = min(x), mean = mean(x), max = max(x))
}

# Apply basics() over temp using vapply()
vapply(temp, basics, numeric(3))



