
# Relational Operators

# operations that help us see how one R object relates to another
	# for example the '==' sign checks if two objects are equal
		# this can compare:
			# logical operators: e.g. TRUE and FALSE
			# strings
			# numbers

TRUE == TRUE
FALSE == TRUE
"hello" == "goodbye"
3 == 2


# similarly there is the inequality operator '!='

TRUE != TRUE
FALSE != TRUE
"hello" != "goodbye"
3 != 2


# can also use inequality operators '>' '<' and '<=' ">="
	# numbers
	# charecter strings
		# sorts in alphabetical order
	# logical values
		# sorts as TRUE = 1 and FALSE = 0

3 < 5
3 > 5
"Hello" > "Goodbye" 
TRUE < FALSE

3 <= 5
3 >= 5
3 >= 3
"Hello" >= "Goodbye" 
TRUE <= FALSE


# using the relational operator on a vector results in a returned vector of logical statements applied to each element

linkedin <- c(16, 9, 13, 5, 2, 17, 14)
linkedin
linkedin > 10

# can compare vectors
	# returns the results of the relational operator for each element

facebook <- c(17, 7, 5, 16, 8, 13, 14)
facebook
linkedin >= facebook


# Comparison of logicals
TRUE == FALSE

# Comparison of numerics
-6 * 14 != 17 - 101

# Comparison of character strings
"useR" == "user"

# Compare a logical with a numeric
TRUE == 1

# Comparison of numerics
-6 * 5 + 2 >= -10 + 1

# Comparison of character strings
"raining" <= "raining dogs"

# Comparison of logicals
TRUE > FALSE

# The linkedin and facebook vectors have already been created for you
linkedin <- c(16, 9, 13, 5, 2, 17, 14)
facebook <- c(17, 7, 5, 16, 8, 13, 14)

# Popular days
linkedin > 15

# Quiet days
linkedin <= 5

# LinkedIn more popular than Facebook
linkedin > facebook


# Compare Matrices
	
# The social data has been created for you
linkedin <- c(16, 9, 13, 5, 2, 17, 14)
facebook <- c(17, 7, 5, 16, 8, 13, 14)
views <- matrix(c(linkedin, facebook), nrow = 2, byrow = TRUE)

# When does views equal 13?
views == 13

# When is views less than or equal to 14?
views <= 14


# Logical Operators
	# what if you want to combine relational operators?
	# R provides logical operators
		# AND operator '&'
		# OR operator '|'
		# NOT operator '!'

# AND only returns TRUE if both are TRUE

TRUE & TRUE
FALSE & TRUE
TRUE & FALSE
FALSE & FALSE

# is x greater than 5 but less than 15

x <- 12
x > 5 & x < 15

x <- 17
x > 5 & x < 15 # simplifies to TRUE & FALSE so this is FALSE

# the OR operator '|'
	# only one of the operations has to be true

TRUE | TRUE
TRUE | FALSE
FALSE | TRUE
FALSE | FALSE

y <- 4
y < 5 | y > 15 # TRUE or FALSE simplifies to TRUE


y <- 14
y < 5 | y > 15 # FALSE or FALSE simplifies to FALSE

# NOT operator !

!TRUE
!FALSE
!(x < 5) # note 'x !< 5' does not work
x>=5

# not operators also work on is.xxx() functions
is.numeric(5)
!is.numeric(5)

is.numeric("hello")
!is.numeric("hello")

# logical operators and vectors

c(TRUE, TRUE, FALSE) & c(TRUE, FALSE, FALSE)

c(TRUE, TRUE, FALSE) | c(TRUE, FALSE, FALSE)

! c(TRUE, FALSE, FALSE)


# & vs && and | vs ||
	# can use either for single elements
	# however, when working with vectors the && and || only return the results of the first elements

c(TRUE, TRUE, FALSE) && c(TRUE, FALSE, FALSE)

c(TRUE, TRUE, FALSE) || c(TRUE, FALSE, FALSE)


# & and |

# the function '3 < x < 7' won't work!
	# you need to run '3 < x & x < 7'

# The linkedin and last variable are already defined for you
linkedin <- c(16, 9, 13, 5, 2, 17, 14)
last <- tail(linkedin, 1)

# Is last under 5 or above 10?
last < 5 | last > 10

# Is last between 15 (exclusive) and 20 (inclusive)?
last > 15 & last <= 20


# linkedin exceeds 10 but facebook below 10
linkedin > 10 & facebook < 10

# When were one or both visited at least 12 times?
linkedin >= 12 | facebook >= 12

# When is views between 11 (exclusive) and 14 (inclusive)?
views > 11 & views <= 14


# li_df is pre-loaded in your workspace

# Select the second column, named day2, from li_df: second
second <- li_df$"day2"

# Build a logical vector, TRUE if value in second is extreme: extremes
	# if second is more than 25 or less than 5
extremes <- (second > 25 | second < 5)

# Count the number of TRUEs in extremes
sum(extremes)

# Solve it with a one-liner
sum((second > 25 | second < 5))