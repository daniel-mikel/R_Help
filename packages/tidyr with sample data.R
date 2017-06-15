#https://rpubs.com/bradleyboehmke/data_wrangling
#This will walk us through the tidyr package

#1 packages utilized: dplyr and tidyr
library("tidyr", lib.loc="~/R/win-library/3.2")
library("dplyr", lib.loc="~/R/win-library/3.2")

#2 A quick summary of the package "tidyr"
##gather() takes multiple columns, and gathers them into key-value pairs: it makes "wide" data longer
##spread() takes two columns (key & value) and spreads in to multiple columns, it makes "long" data wider
##separate() splits a single column into multiple columns
##unite() combines multiple columns into a single column

#3 Load the test data
## This is the simplified version of an already simplified dataset, just has Simple.Average, no other variables
Placeholder <- read.csv("C:\\Users\\Daniel\\Desktop\\Year of the Positive Vibe\\Econ Take 2\\Thesis\\Data\\Test Data\\Custom Data with only Tariffs.csv")
MyData <- tbl_df(Placeholder)

## This is the 'full' dataset
AlmostFullData <- read.csv("C:\\Users\\Daniel\\Desktop\\Year of the Positive Vibe\\Econ Take 2\\Thesis\\Data\\Test Data\\Custom Data_Only the essentials.csv")
FullData <- tbl_df(AlmostFullData)

##Test data from the internet
NotYetTestData <- read.csv("C:\\Users\\Daniel\\Desktop\\Year of the Positive Vibe\\Econ Take 2\\Thesis\\Data\\Test Data\\tidyr test data.csv")
TestData <- tbl_df(NotYetTestData)

View(Data)
View(TestData)

#4 we want to use the spread() function to get our 'long' data into the 'wide' format
##This didn't quit work, going to work through the website tutorial
Data %>% spread(Simple.Average, DutyType, fill = NA, convert = FALSE)
wide_DF <- Data %>% spread(DutyType, Simple.Average)
head(wide_DF, 24)
View(wide_DF)

#5 the gather() function
long_DF <- TestData %>% gather(Quarter, Revenue, Qtr.1:Qtr.4)
View(long_DF)


TestData %>% gather(Quarter, Revenue, Qtr.1:Qtr.4)
TestData %>% gather(Quarter, Revenue, -Group, -Year)
TestData %>% gather(Quarter, Revenue, 3:6)
TestData %>% gather(Quarter, Revenue, Qtr.1, Qtr.2, Qtr.3, Qtr.4)

#6 the spread() function
##This does the opposite of what we want, but is necissary  to get test data into 'long form' to fix into 'wide form'
wide_DF <- long_DF %>% spread(Quarter, Revenue)
head(wide_DF, 24)
View(wide_DF)
long_DF%>% spread(Quarter, Revenue, Qtr.1:Qtr.4)


#7 Now we try to convert my data to the wide from
## A breakthrough! Able to use this function, but had to scrub data
wide_MyData <- MyData %>% 
  spread(DutyType, Simple.Average)
View(wide_MyData)


#8 we test the unite() function, this will allow us to combine columns to use FullData
##This part works
FullDataColumns1 <- unite(FullData, Average.By.Duty, DutyType.4.Tariff, DumC_SimpleAverage, sep = " ", remove = TRUE)
FullDataColumns2 <- unite(FullDataColumns1, Volume.By.Duty, DutyType.4.Volume, DumC_Volume, sep = " ", remove = TRUE)
View(FullDataColumns2)


#9 We try the spread() function with custum data with volume included
## Almost there... 
Fire <- FullDataColumns2 %>% 
  spread(Average.By.Duty, Simple.Average) %>% 
  spread(Volume.By.Duty, Imports.Value.in.1000.USD)
View(Fire)

#10 A different approach
## We're going to split the dataframe in two, process with spread() independently, and then recombine

#Subset to work with Tariffs
SubTariff <- FullDataColumns2 %>%
  select(Product, Tariff.Year, Average.By.Duty, Simple.Average)

#Subset to work with Volumes
SubVolume <- FullDataColumns2 %>%
  select(Product, Tariff.Year, Volume.By.Duty, Imports.Value.in.1000.USD)

#We've got the subs, now we work each sub_df, then work both as in (#7), then recombine
Wide_Tariff <- SubTariff %>% 
  spread(Average.By.Duty, Simple.Average)
View(Wide_Tariff)

Wide_Volume <-SubVolume %>%
  spread(Volume.By.Duty, Imports.Value.in.1000.USD)
View(Wide_Volume)

#We've finished working the dataframes independintly, now to recombine
total <- merge(Wide_Tariff, Wide_Volume, by=c("Product","Tariff.Year"))
View(total)


