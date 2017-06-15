#Tutorial on apply() functions
  #https://www.youtube.com/watch?v=ejVWRKidi9M

#This is the second in a series on the apply() family of functions

#Part 2 of 4

############
# lapply() #
############
#similar to apply()
  #can be a list, dataframe, or vector
  #however, lapply() only returns lists!

#lapply() with a list of vectors
CAGO.list<-list(Diet1=c(2,5,4,5,3,5,4,4,4,5), Diet2=c(8,5,6,5,7,7,6,8,8,3), 
                Diet3=c(3,4,2,5,2,6,5,6,2,4), Diet4=c(2,2,3,2,5,2,4,3,5,7))
CAGO.list
lapply(CAGO.list, mean) #outputs the mean of each list

#lapply() with dataframe
CAGO.df<-data.frame(Diet1=c(2,5,4,5,3,5,4,4,4,5), Diet2=c(8,5,6,5,7,7,6,8,8,3), 
                Diet3=c(3,4,2,5,2,6,5,6,2,4), Diet4=c(2,2,3,2,5,2,4,3,5,7))
CAGO.df
lapply(CAGO.df, mean) #same as apply(), but lapply() assumes we use columns

#lapply() can also work with charector vectors
Random<-c("This","is","a","Random","Vector")
Random
lapply(Random, nchar) #number of charecters in each string, retunred as a list
nchar(Random) #same answer except the return is a vector

############
# sapply() #
############

#can input list, dataframe, or vector 
  #however, sapply() tryies to simplify the return
sapply(CAGO.list, mean) #returned as a vector, not a list as lapply()
sapply(CAGO.df, mean) #same return as lapply(), but as a vector
sapply(Random, nchar) #same return as nchar(), but as a vector

#what happens with sapply() when the output can't be simplified
sequence<-function(x){
  seq(nchar(x))
}

sapply(Random, sequence) #a list is returned, like in lapply()


