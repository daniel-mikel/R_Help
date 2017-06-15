#part 6: for loops
#https://campus.datacamp.com/courses/writing-functions-in-r/a-quick-refresher?ex=13

#for loops are used for iteration
primes_list <- list(2,3,5,7,11,13) #list of first 6 prime numbers

#from 1 to the length of primes_list, print the ith value of primes list 
for (i in 1:length(primes_list)){   #sequence 
  print(primes_list[[i]])   #body
}

#the three parts of a for loop
  #sequence:
    #gives name we give to the object that indexes the iterations
    #gives the values of the index this object iterates over
  #body:
    #the part between the curly brackets
    #describes the operations to iterate
  #output
    #where to store the result (in the example above this is missing) 

df <- data.frame(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10))
df

for (i in 1:ncol(df)){ #start at 1st column and end at the last column
  print(median(df[[i]])) #calls each column specified in the sequence
}

# exercises #
#############

#we have the for loop:
for (i in 1:ncol(df)) {
  print(median(df[[i]]))
}
#This is a pretty common model for a sequence: 
  #a sequence of consecutive integers 
  #designed to index over one dimension of our data.
#however, "i in 1:ncol(df)" is not the best way generate a sequence
  #especially when using for loops inside your own functions
#for example, say we have an empty dataframe

df <- data.frame() #data frame is an empty set
1:ncol(df) #from 1 to 0 doesn't make much sense...

for (i in 1:ncol(df)) { #gives us an error
  print(median(df[[i]]))
}

for (i in seq_along(df)){
  print(median(df[[i]]))
}

# keeping output #
##################

#the above for loops do a good job of displaying the computed values
  #now we want to store them

#before you start a loop, you must allocate sufficient space for the output
  #this is important for efficiency
    #if you frow the for loop at each iteration, it may become very slow
  #at each iteration, the loop will store the output to the coresponding entry of the output vector
    #i.e. it will assign the result to output[[i]]

#create a new "double" vector of length ncol(df) and name it "output"
df <- data.frame(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10))

output <- vector(mode="double", length=ncol(df))

for (i in seq_along(df)) { #using seq_along instead of 1:ncol(df)
  output[[i]] <- (median(df[[i]])) #store outputs in the ith position of the vector
}

# Print output
print(output)
