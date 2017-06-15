

#packages
library(plyr)
library(dplyr)

#dummy data
  #this data mimics panel time series data with 2 comodities
    #wtih multiple reporters 
    #not similar reporters
    #each 'x', 'y', 'z' is a new year in the time series
    #note respondents have different capitalizations
    #column in df ARE in the same order

x <- data.frame(i = c("a","b","c"), j = 1:3, k = 10:12)
y <- data.frame(i = c("b","C","d"), j = 4:6, k = 13:15)
z <- data.frame(i = c("c","d","A"), j = 7:9, k = 16:18)

my.list <- list(x = x, y = y, z = z) 
str(my.list) 

#manipulate first column in each df in list for merge
  #need to change factor vector into character vector, then make all into uppercase

output.list <- NULL #output vector 

for (i in 1:length(my.list)){
  temp.df <- my.list[[i]]
  temp.df[[1]] <- as.character(temp.df[[1]])
  temp.df[[1]] <- toupper(temp.df[[1]])
  output.list[[i]] <- temp.df
}
names(output.list) <- names(my.list) #keep the names on the list objects, useful later
str(output.list)

#now we need to subset the data by commodity
  #we return a series of lists
    #one list for each commodity
    #each element of the list is a dataframe 
      #with two columns, each respondent and their value for that commodity

all.j <- NULL
for (i in 1:length(output.list)){
  new.df <- data.frame(output.list[[i]][[1]])
  new.df[[2]] <- output.list[[i]][[2]]
  names(new.df)[1] <- names(output.list[[i]][1])
  names(new.df)[2] <- names(output.list[[i]][2])
  all.j[[i]] <- new.df
}
all.j

all.k <- NULL
for (i in 1:length(output.list)){
  new.df <- data.frame(output.list[[i]][[1]])
  new.df[[2]] <- output.list[[i]][[3]]
  names(new.df)[1] <- names(output.list[[i]][1])
  names(new.df)[2] <- names(output.list[[i]][3])
  all.k[[i]] <- new.df
}
all.k

#now we need to merge the dataframes in our list into a single historic dataframe
j.df <- all.j[[1]]
for (i in 2:length(all.j)){
  j.df <- merge(x = j.df, y = all.j[[i]], by = "i", all = TRUE)
}
names(j.df)[2:4] <- names(my.list)
j.df

k.df <- all.k[[1]]
for (i in 2:length(all.k)){
  k.df <- merge(x = k.df, y = all.k[[i]], by = "i", all = TRUE)
}
names(k.df)[2:4] <- names(my.list)
k.df

#now declare commodity specific dataframes as time series objects
