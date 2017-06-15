#Tutorial on apply() functions
#https://www.youtube.com/watch?v=HmBPDTtb6Bg

#This is the third in a series on the apply() family of functions

#Part 3 of 4

############
# tapply() #
############
#allows funcitons to be applied to subsets of a vector

#tapply(x, Index, function,...)
  #x is an object is a vector, column of a data frame, element of a list
  #Index is a vector the same length of x that contains factors to subset x
  #function is the applied function

PatientID<-1:30
PatientID

Age<-c(32,45,44,34,23,26,37,45,12,23,44,35,57,65,76,
       43,42,34,36,37,23,21,28,24,29,13,18,32,25,28)
Age
Treatment<-c("a","c","c","b","b","b","c","b","c","a","a","a","a","a","b",
             "b","b","b","b","c","c","c","a","b","c","b","a","a","c","a")
Treatment

#say we want to take the mean of the ages for each treatment
mean(Age) #only gives us the mean of all treatments
tapply(Age,Treatment,mean)

#we can do the same with dataframes too
Med.df<-data.frame(PatientID, Treatment, Age)
Med.df
tapply(Med.df$Age,Med.df$Treatment,mean) #returns the same thing as above


#we can do the same with lists too
Med.list<-list(PatientID=PatientID, Treatment=Treatment, Age=Age)
Med.list
tapply(Med.list$Age,Med.list$Treatment,mean) #returns the same as above

#note: plyr and dplyr have functions that do similar things
