#dplyr

#from youtube video: https://www.youtube.com/watch?v=jWjqLW-u3hc
##

rm(list=ls())
View(Data)

# load packages
library(dplyr)

# explore data
Test <- read.csv("C:\\Users\\Daniel\\Desktop\\Year of the Positive Vibe\\Econ Take 2\\Thesis\\Data\\Test Data\\Custom Data.csv")
head(Test)

library(hflights)
data(hflights)
head(hflights)
```

* `tbl_df` creates a "local data frame"
* Local data frame is simply a wrapper for a data frame that prints nicely

```{r}
# convert to local data frame
Data <- tbl_df(Test)

# printing only shows 10 rows and as many columns as can fit on your screen
Data
```

```{r results='hide'}
# you can specify that you want to see more rows
print(Data, n=5)

# convert to a normal data frame to see all of the columns
data.frame(head(Data))
```


## filter: Keep rows matching criteria
* Base R approach to filtering forces you to repeat the data frame's name
* dplyr approach is simpler to write and read
* Command structure (for all dplyr verbs):
* first argument is a data frame
* return value is a data frame
* nothing is modified in place
* Note: dplyr generally does not preserve row names

```{r results='hide'}
# base R approach to view all flights on January 1
Data[Data$Product==111111 & Data$Trade.Year==2000, ]
```

```{r}
# dplyr approach
# note: you can use comma or ampersand to represent AND condition
filter(Data, Product==111111, Trade.Year==2000)

# use pipe for OR condition
##Apparently this can be used to filter multiple columns
filter(Data, Product=="111111" | Tariff.Year=="2001")
```

```{r results='hide'}
# you can also use %in% operator
##Probably can't be used to 
filter(Data, Product %in% c("111111", "222222"))
```


## select: Pick columns by name

* Base R approach is awkward to type and to read
* dplyr approach uses similar syntax to `filter`
* Like a SELECT in SQL

```{r results='hide'}
# base R approach to select DepTime, ArrTime, and FlightNum columns
Data[, c("Product", "Trade.Year", "Simple.Average")]
```

```{r}
# dplyr approach
select(Data, Product, Trade.Year, Simple.Average)

# use colon to select multiple contiguous columns, and use `contains` to match columns by name
# note: `starts_with`, `ends_with`, and `matches` (for regular expressions) can also be used to match columns by name
select(Data, Trade.Year:Simple.Average, contains("MFN"), contains("Chicken"))
```


## "Chaining" or "Pipelining"

* Usual way to perform multiple operations in one line is by nesting
* Can write commands in a natural order by using the `%>%` infix operator (which can be pronounced as "then")

```{r results='hide'}
# nesting method to select UniqueCarrier and DepDelay columns and filter for delays over 60 minutes
filter(select(Data, Product, Trade.Year, Simple.Average), Simple.Average> 10)
##Or
SimpleAverageOver10<-filter(select(Data, Product, Trade.Year, Simple.Average), Simple.Average> 10)
SimpleAverageOver10
```

```{r}
# chaining method
## Can't get this chainging to work 
Data %>% select(Data, Product, Trade.Year, Simple.Average) %>% filter(Trade.Year > 10)

```

* Chaining increases readability significantly when there are many commands
* Operator is automatically imported from the [magrittr](https://github.com/smbache/magrittr) package
* Can be used to replace nesting in R commands outside of dplyr

```{r results='hide'}
# create two vectors and calculate Euclidian distance between them
x1 <- 1:5; x2 <- 2:6
sqrt(sum((x1-x2)^2))
```

```{r}
# chaining method
(x1-x2)^2 %>% sum() %>% sqrt()
```


## arrange: Reorder rows

```{r results='hide'}
# base R approach to select UniqueCarrier and DepDelay columns and sort by DepDelay
Data[order(Data$Simple.Average), c("Product", "Trade.Year", "Simple.Average")]
```

```{r}
# dplyr approach
##can work for as many 'select's as needed. 'arrange()' must be an item selected in 'select'
Data %>% select(Product, Trade.Year, Simple.Average) %>% arrange(Simple.Average)
```

```{r results='hide'}
# use `desc` for descending
##Same deal as above
Data %>%  select(Product, Trade.Year, Simple.Average) %>% arrange(desc(Simple.Average))
```


## mutate: Add new variables

* Create new variables that are functions of existing variables

```{r results='hide'}
# base R approach to create a new variable Speed (in mph)
data$A.Useless.Value <- data$Imports.Value.in.1000.USD /data$Simple.Average *.01
data[, c("Product", "Trade.Year", "A.Useless.Value")]
```

```{r}
# dplyr approach (prints the new variable but does not store it)
data %>% select(Imports.Value.in.1000.USD, Simple.Average) %>%  mutate(Speed = Imports.Value.in.1000.USD/Simple.Average*.01)
# store the new variable
Data <- data %>% mutate(Second.Useless.Value = Imports.Value.in.1000.USD/Simple.Average*0.01)
```


## summarise: Reduce variables to values

* Primarily useful with data that has been grouped by one or more variables
* `group_by` creates the groups that will be operated on
* `summarise` uses the provided aggregation function to summarise each group

```{r results='hide'}
# base R approaches to calculate the average arrival delay to each destination
head(with(Data, tapply(Simple.Average, Product, mean, na.rm=TRUE)))
head(aggregate(Simple.Average ~ Product, Data , mean))
```

```{r}
# dplyr approach: create a table grouped by Dest, and then summarise each group by taking the mean of ArrDelay
data %>% group_by(Product) %>% summarise(avg_tariff= mean(Simple.Average, na.rm=TRUE))

##now we try this with new data with missing row, having problems "Error: object 'True' not found
DataWO <- read.csv("C:\\Users\\Daniel\\Desktop\\Year of the Positive Vibe\\Econ Take 2\\Thesis\\Data\\Test Data\\Custom Data Minus One Row.csv")

DataWO %>% group_by(Product, Trade.Year) %>% summarise(avg_tariff= mean(Simple.Average, na.rm=True))
```

* `summarise_each` allows you to apply the same summary function to multiple columns at once
* Note: `mutate_each` is also available

```{r}
# for each Product, calculate the percentage of flights cancelled or diverted
## The group_by() command can handle one or at least two subgroupings
Data %>% 
group_by(Product, Trade.Year) %>% 
summarise_each(funs(mean), Simple.Average, Imports.Value.in.1000.USD)

# for each carrier, calculate the minimum and maximum arrival and departure delays
Data %>%
group_by(Product, DutyType) %>%
summarise_each(funs(min(., na.rm=TRUE), max(., na.rm=TRUE)), matches("Simple.Average"))
```

* Helper function `n()` counts the number of rows in a group
* Helper function `n_distinct(vector)` counts the number of unique items in that vector

```{r}
# for each day of the year, count the total number of flights and sort in descending order
## We can use this function to 'tally' the incidences of the available data
## by grouping Product and DutyType, we get the number of years that have an entry for each Product of that Duty Type
Data %>%
group_by(Product, DutyType) %>%
summarise(tariff.code.count = n()) %>%
arrange(desc(tariff.code.count))

# rewrite more simply with the `tally` function
Data %>%
group_by(Product, DutyType) %>%
tally(sort = TRUE)

# for each destination, count the total number of flights and the number of distinct planes that flew there
## This could be used to see if there are holes in the data/where they are
Data %>%
group_by(Product, DutyType) %>%
summarise(Recorded_Lines = n(), Codes_Entered = n_distinct(Trade.Year))
```

* Grouping can sometimes be useful without summarising

```{r}
# for each destination(Product), show the number of cancelled(PRF) and not cancelled(MFN) flights(tariff lines)
Data %>%
group_by(Product) %>%
select(DutyType) %>%
table() %>%
head()
```


## Window Functions

* Aggregation function (like `mean`) takes n inputs and returns 1 value
* [Window function](http://cran.r-project.org/web/packages/dplyr/vignettes/window-functions.html) takes n inputs and returns n values
* Includes ranking and ordering functions (like `min_rank`), offset functions (`lead` and `lag`), and cumulative aggregates (like `cummean`).

```{r results='hide'}
# for each carrier (Product), calculate which two days of the year they had their longest(hightest) departure delays (Tariff percent)
# note: smallest (not largest) value is ranked as 1, so you have to use `desc` to rank by largest value
Data %>%
group_by(Product) %>%
select(Trade.Year, DutyType, Simple.Average, Imports.Value.in.1000.USD) %>%
filter(min_rank(desc(Imports.Value.in.1000.USD)) <= 2) %>%
arrange(Product, desc(Imports.Value.in.1000.USD))
```

```{r}
# rewrite more simply with the `top_n` function
Data %>%
group_by(Product) %>%
select(Trade.Year, DutyType, Imports.Value.in.1000.USD, Simple.Average) %>%
top_n(2) %>%
arrange(Product, desc(Simple.Average))

# for each month, calculate the number of flights and the change from the previous month
Data %>%
group_by(Product, DutyType, Trade.Year) %>%
summarise(Imports.Value.in.1000.USD = n()) %>%
mutate(change = (Imports.Value.in.1000.USD - lag(Imports.Value.in.1000.USD)))

# rewrite more simply with the `tally` function
Data %>%
group_by(Product, Trade.Year, DutyType) %>%
tally() %>%
mutate(change = Simple.Average - lag(Simple.Average))
```


## Other Useful Convenience Functions

```{r}
# randomly sample a fixed number of rows, without replacement
Data %>% sample_n(5)

# randomly sample a fraction of rows, with replacement
Data %>% sample_frac(0.25, replace=TRUE)

# base R approach to view the structure of an object
str(Data)

# dplyr approach: better formatting, and adapts to your screen width
glimpse(Data)
```


## Connecting to Databases

* dplyr can connect to a database as if the data was loaded into a data frame
* Use the same syntax for local data frames and databases
* Only generates SELECT statements
* Currently supports SQLite, PostgreSQL/Redshift, MySQL/MariaDB, BigQuery, MonetDB
* Example below is based upon an SQLite database containing the hflights data
* Instructions for creating this database are in the [databases vignette](http://cran.r-project.org/web/packages/dplyr/vignettes/databases.html)

```{r}
# connect to an SQLite database containing the hflights data
my_db <- src_sqlite("my_db.sqlite3")

# connect to the "hflights" table in that database
flights_tbl <- tbl(my_db, "hflights")

# example query with our data frame
flights %>%
select(UniqueCarrier, DepDelay) %>%
arrange(desc(DepDelay))

# identical query using the database
flights_tbl %>%
select(UniqueCarrier, DepDelay) %>%
arrange(desc(DepDelay))
```

* You can write the SQL commands yourself
* dplyr can tell you the SQL it plans to run and the query execution plan

```{r}
# send SQL commands to the database
tbl(my_db, sql("SELECT * FROM hflights LIMIT 100"))

# ask dplyr for the SQL commands
flights_tbl %>%
select(UniqueCarrier, DepDelay) %>%
arrange(desc(DepDelay)) %>%
explain()
```


## Resources

* [Official dplyr reference manual and vignettes on CRAN](http://cran.r-project.org/web/packages/dplyr/index.html): vignettes are well-written and cover many aspects of dplyr
* [July 2014 webinar about dplyr (and ggvis) by Hadley Wickham](http://pages.rstudio.net/Webinar-Series-Recording-Essential-Tools-for-R.html) and related [slides/code](https://github.com/rstudio/webinars/tree/master/2014-01): mostly conceptual, with a bit of code
* [dplyr tutorial by Hadley Wickham](https://www.dropbox.com/sh/i8qnluwmuieicxc/AAAgt9tIKoIm7WZKIyK25lh6a) at the [useR! 2014 conference](http://user2014.stat.ucla.edu/): excellent, in-depth tutorial with lots of example code (Dropbox link includes slides, code files, and data files)
* [dplyr GitHub repo](https://github.com/hadley/dplyr) and [list of releases](https://github.com/hadley/dplyr/releases)


< END OF DOCUMENT >