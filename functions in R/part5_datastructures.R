#data structures
  #https://campus.datacamp.com/courses/writing-functions-in-r/a-quick-refresher?ex=9

# vecors #
##########

#two types of vectors in R: atomic and list.

#atomic vectors (can only contain one type of data structure)
  #six types:
    #logical
    #integer
    #double
    #character
    #complex
    #raw

#lists (can contain heterogenious data structures)
  #a.k.a. recursive vectors, because lists can contain other lists

#every vector has two key properties
  #its type, can be found with typeof()
typeof(letters)
typeof(1:10)
  #its length, find with length()
length(letters)
x <- list("a", "b", 1:10)
length(x)

#metadata can be added to a vector through attributes
  #leads to augmented vectors
  #a more complicated data structure

#Missing values 
  #'NULL' indicates the absense of a vector
typeof(NULL)
length(NULL)
  #NA indicates the absense of a value inside a vector
typeof(NA)
length(NA)

#if NA is inside a vector
  #that value was unobserved, or unobtainable for a particular operation
x <- c(1, 2, 3, NA, 5)
x
is.na(x) #returns a logical vector of TRUE if NA

#NA is contagious, operations with NA result in NA
NA + 10
NA / 2
NA > 5
10 == NA #this include logical comparisons with an NA
NA == NA

# lists #
#########

#lists are useful because they can contain heterogeneous objects
#means they're useful for complicated return objects
#lists are created with list()
#lists can be subset with [, [[, or $
  #[ extracts a sublist
  #[[ and $ extract elements, remove a level of hierarchy

a <- list(
  a = 1:3,
  b = "a string",
  c = pi,
  d = list(-1, -5)
)

a[4] #asks for the 4th element in list 'a'
a[1:2] #asks for the first two elements in list 'a'
a[[4]][1] #asks for the 2nd element of the 4th element of list 'a'

str(a[4]) #asks for a list of 1 element (which is a list of 2 elements)
str(a[[4]]) #asks for the 4th object as its element, here it returns 2 elements (of 1 element each)

#answers to question section
#there is a list defined in DataCamp called tricky_list
  #it is a list made up of several elements, including models
  #tricky_list isn't defined here

# Guess where the regression model is stored
names(tricky_list)

# Use names() and str() on the model element
names(tricky_list[["model"]]) #gives the names of the top level of the list
str(tricky_list[["model"]]) #like list but gives much more information

# Subset the coefficients element
tricky_list[["model"]][["coefficients"]]

# Subset the wt element
tricky_list[["model"]][["coefficients"]][["wt"]]
