#Tutorial on apply() functions
  #https://www.youtube.com/watch?v=f0U74ZvLfQo

#This is the first in a series on the apply() family of functions

#Part 1 of 4

###########
# apply() #
###########

#apply() is essentially a loop that iterate over the elements of an object
  #object can be DataFrame or list
  #executes a specific command over those objects

#takes a minimum of 3 arguments:
  #apply(object, margin, funciton, ...)
    #object can be a DataFrame or an Array
    #margin specifies which dimention to iterate over
      #i.e. columns, rows, or both
        # 1 = row
        # 2 = column
        # c(1,2) = rows and columns
        # etc.
    # functions to apply to these given dimensions

Duckweed.mat <- matrix(c(10,20,30,40,50,60,70,80,90,100,
                         10,30,50,80,100,150,200,250,270,300,
                         10,30,36,80,96,106,110,130,136,144,
                         10,15,30,50,70,86,95,100,105,190,
                         10,40,50,60,78,96,107,120,144,157,
                         10,30,57,98,106,130,160,177,189,198),
                       nrow=10, byrow=FALSE)

rownames(Duckweed.mat) <- c("Day1", "Day2", "Day3", "Day4", "Day5", "Day6", "Day7", "Day8",
                            "Day9", "Day10")

Duckweed.mat

#now we want to find the max value in each row
max(Duckweed.mat[1,]) #gives us the max value of the first row
#it would be too much writing to do it explicitly for each line

#for loops would also take a fair amount of code
for (i in 1:10){
  row<-Duckweed.mat[i,]
  max<-max(row)
  print(max)
}

#the apply funciton allows us to do the same thing with just a little bit of code
apply(Duckweed.mat, 1, max) #returns same output as the for loop generated

apply(Duckweed.mat, 2, max) #does the same as above, but for the columns

###########################
# apply() with DataFrames #
###########################
#you can do the same for dataframes

Duckweed.df <- data.frame(R1=c(10,20,30,40,50,60,70,80,90,100),
                         R2=c(10,30,50,80,100,150,200,250,270,300),
                         R3=c(10,30,36,80,96,106,110,130,136,144),
                         R4=c(10,15,30,50,70,86,95,100,105,190),
                         R5=c(10,40,50,60,78,96,107,120,144,157),
                         R6=c(10,30,57,98,106,130,160,177,189,198))
Duckweed.df                         

#now we want to means of the rows in the DataFrame
apply(Duckweed.df, 1, mean) #same as before, but for the mean() function

#what if the first column was a factor?
  #they are there to show the days of the week
  #these would be numbers that we don't want to manipulate
Duckweed.df$Day <- as.factor(1:10) #creating the 'day' column
Duckweed.df<-Duckweed.df[,c(7,1:6)] #rearrange the columns
Duckweed.df #view DataFrame
class(Duckweed.df$Day) #making sure the first row was a column

#we want to exclude the first column because its a factor
apply(Duckweed.df[,2:7],1,mean) #[,2:7] specifies the 2nd through 7th columns 
apply(Duckweed.df[,-1],1,mean) #same as above, but specifies to exclude the 1st column instead
apply(Duckweed.df[,-c(1,2,4,6)],1,mean) #can also exclude a vecor of column positions to exclude

#what if we have NAs in our data?
Duckweed.df[6,7]<-NA
Duckweed.df
apply(Duckweed.df[,-1],1,mean) #breaks on the 6th row which has the NA
apply(Duckweed.df[,-1],1,mean, na.rm=TRUE) #normally in mean(..., na.rm=TRUE), here we add it to apply

#now we want to make our own function to use with apply()
Prop<-function(x){ 
  x/max(x)
  }
apply(Duckweed.mat, 2, Prop)

#apply() is especially powerful, because it can return matrixs and not just vectors

