#data
x <- data.frame(first = c("a","b","c"), second = 1:3, third = 10:12)
y <- data.frame(first = c("b","C","d"), second = 4:6, third = 13:15)
z <- data.frame(first = c("c","d","A"), second = 7:9, third = 16:18)

my.list <- list(x = x, y = y, z = z) 
str(my.list) 

#clean data for later merge
output.list <- NULL #output vector 
for (i in 1:length(my.list)){
  temp.df <- my.list[[i]]
  temp.df[[1]] <- as.character(temp.df[[1]])
  temp.df[[1]] <- toupper(temp.df[[1]])
  output.list[[i]] <- temp.df
}
names(output.list) <- names(my.list) #keep the names on the list objects, useful later
str(output.list)

#subset data by commodity in new list
comm.list <- NULL
all.jth <- NULL
names.vector <- c(1:2) #we will need this to name output dataframes in list

for (i in 2:length(x[[1]])){
  names(names.vector)[[i - 1]] <- paste("all", names(output.list[[1]][i]), sep=".")
  }
names.vector #sloppy but it should work

for (j in 2:length(output.list[[1]])){
  for (i in 1:length(output.list)){
    new.df <- data.frame(output.list[[i]][[1]])
    new.df[[2]] <- output.list[[i]][[j]]
    names(new.df)[1] <- names(output.list[[i]][1])
    names(new.df)[2] <- names(output.list[[i]][j])
    all.jth[[i]] <- new.df
  }
  comm.list[[j-1]] <- all.jth
}  

names(comm.list) <- names(names.vector)
comm.list

#make lists into df
df.list <- NULL

for (j in 1:length(comm.list)){
  temp.df <- comm.list[[j]][1]
  for (i in 2:length(comm.list[[j]])){
    temp.df <- merge(x = temp.df, y = comm.list[[j]][i], by = "first", all = TRUE)
  }
  df.list[[j]] <- temp.df
  names(df.list[[j]])[2:(1+length(my.list))] <- names(my.list)
}
names(df.list) <- names(comm.list)
df.list

