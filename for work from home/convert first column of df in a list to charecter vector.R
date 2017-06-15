#packages
library(plyr)
library(dplyr)

#dummy data
my.vector <- as.factor(c("a","b","c"))

my.df <- data.frame(i = c("a","b","c"), j = 1:3)
y <- data.frame(i = c("b","c","d"), k = 4:6)
z <- data.frame(i = c("c","d","a"), l = 7:9)

my.list <- list(my.df ,y ,z) 

#describe data
str(my.vector)
str(my.df)
str(my.list)

my.vector.c <- as.character(my.vector)
str(my.vector.c)

my.df.c <- as.character(my.df$i)
my.df.c.c <- as.character(my.df[[1]])
str(my.df.c)
str(my.df.c.c)

my.list.c <- as.character(my.list$i)
my.list.c

my.list.sub <- my.list[[1]]
str(my.list.sub)

#we convert the first column of every df in list to a charecter vector
output.list <- NULL #output vector saved in global enviornment

for (i in 1:length(my.list)){
  temp.df <- my.list[[i]]
  temp.df[[1]] <- as.character(temp.df[[1]])
  output.list[[i]] <- temp.df
}
str(output.list)

#same loop with another function to make charecter vector into upper case characters
output.list <- NULL 

for (i in 1:length(my.list)){
  temp.df <- my.list[[i]]
  temp.df[[1]] <- as.character(temp.df[[1]])
  temp.df[[1]] <- toupper(temp.df[[1]])
  output.list[[i]] <- temp.df
}
str(output.list)

