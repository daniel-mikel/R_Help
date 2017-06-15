#merging dataframes from lists
#http://stackoverflow.com/questions/8091303/simultaneously-merge-multiple-data-frames-in-a-list

#http://stackoverflow.com/questions/17499013/how-do-i-make-a-list-of-data-frames
  #excellent example!

#######################
# from stack overflow #
#######################

#packages
library(dplyr)

#dummy data
x <- data_frame(i = c("a","b","c"), j = 1:3)
y <- data_frame(i = c("b","c","d"), k = 4:6)
z <- data_frame(i = c("c","d","a"), l = 7:9)

#multiple left joins
list(x,y,z) %>%
  Reduce(function(dtf1,dtf2) left_join(dtf1,dtf2,by="i"), .)

#outer join
list(x,y,z) %>%
  Reduce(function(dtf1,dtf2) full_join(dtf1,dtf2,by="i"), .)

#inner join
list(x,y,z) %>%
  Reduce(function(dtf1,dtf2) inner_join(dtf1,dtf2,by="i"), .)


###################################################
# make list and then delete columns using apply() #
###################################################
#http://stackoverflow.com/questions/12612460/lapply-and-subsetting-columns
#http://stackoverflow.com/questions/9469504/access-and-preserve-list-names-in-lapply-function

#(1) subset a list using lapply() and save it as another list
#(2) consolidate that set of lists 

#package
library(plyr)

x <- data_frame(i = c("a","b","c"), 
                j = 1:3,
                k = 4:6)
y <- data_frame(i = c("b","c","d"), 
                j = 7:9,
                k = 10:12)
z <- data_frame(i = c("c","d","a"), 
                j = 13:15,
                k = 16:18)
a.list <- list(x,y,z) #does not preserve df names in list MAY NOT WORK IF YOU NEED DF NAMES LATER
b.list <- list(x = x, y = y, z = z) #does preserve df names in list

j.list <- lapply(b.list, FUN = function(x){x[, c(1,2)]}) #works, names may drop but don't here
p.list <- llply(b.list, function(x){x[, c(1,2)]}) #same as lapply() but keeps the names of the dataframes

str(a.list)
str(b.list)
str(j.list)
str(p.list)

#this uses the pipe from dplyr
  #seems to work, but drops one of the 
big_data <- p.list %>%
  Reduce(function(dtf1,dtf2) full_join(dtf1,dtf2, by="i"), .)
big_data


# now that we have the proof of concept, we do it with the dummy data #
#######################################################################
first.list <- llply(b.list, function(x){x[, c(1,2)]})
second.list <- llply(b.list, function(x){x[, c(1,3)]}) 

first.list
second.list

all.of.j<- first.list %>%
  Reduce(function(dtf1,dtf2) full_join(dtf1,dtf2,by="i"), .)
all.of.k<- second.list %>%
  Reduce(function(dtf1,dtf2) full_join(dtf1,dtf2,by="i"), .)

all.of.j
all.of.k

#this works! we just need to rename the column headers!
  #








################
# Doesn't work #
################

#this consolidates into a single dataframe
  #its long, and it would be hard to subset with arbitrary naming conditions after the join

#packages
library(dplyr)

#data
nfi2012.1 <- data_frame(firm = c("a","b","c"), 
                     cow = 1:3,
                     pig = 1:3,
                     sheep = 5:7)
nfi2012.2 <- data_frame(firm = c("a","b","c"), 
                     cow = 7:9,
                     pig = 2:4,
                     sheep = 1:3)
nfi2013.1 <- data_frame(firm = c("a","b","c"), 
                     cow = 11:13,
                     pig = 4:6,
                     sheep = 3:5)
nfi2013.2 <- data_frame(firm = c("a","b","c"), 
                     cow = 13:15,
                     pig = 6:8,
                     sheep = 0:2)
nfi <- list(nfi2012.1, nfi2012.2, nfi2013.1, nfi2013.1) %>%
  Reduce(function(dtf1,dtf2) full_join(dtf1,dtf2,by="firm"), .)  
nfi
