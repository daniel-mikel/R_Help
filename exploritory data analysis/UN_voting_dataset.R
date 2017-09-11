# this is based on a datacamp tutorial
	# https://campus.datacamp.com/courses/exploratory-data-analysis-in-r-case-study/data-cleaning-and-summarizing-with-dplyr?ex=2


library("dplyr")
library("unvotes") # includes multiple UN datasets
library("countrycode") # in datacamp this is library("ccode")

# library("unvotes") 

# information on each roll call vote of the UN General Assembly
glimpse(un_roll_calls)

# topic classifications of roll call votes of the UN Gen. Ass.
	# many votes had no topic, and some have more than one
glimpse(un_roll_call_issues)

# information on voting history of the UN Gen Assembly
	# contains one row for each country-vote pair
glimpse(un_votes)


#############################
# getting the datacamp data #
#############################

# I downloaded this from the author's github:
votes <- readRDS("/home/dan/R/R_Help/exploritory data analysis/votes.rds")

# this gets a dataset similar to the one in the tutorial
	# data cleaned from library("unvotes")
	# some major differences
		# notably, no votes for 'abstain' and 'not present'
		# I was lazy and couldn't get the Federal Republic of Germany to work properly
			# I just made them Germany for those years...
		# has every year instead of every other year 
	# can still reproduce datacamp coursework in desktop
	

joined <- un_votes %>%
  inner_join(un_roll_calls, by = "rcid")

# similar, but still not quite the same...
glimpse(joined)
unique(joined$vote)

mute_votes <- data.frame(
	c("yes", "no", "abstain"), 
	c(1,3,2)
	)
names(mute_votes) <- c("vote", "vote_as_num")
print(mute_votes)

joined1 <- joined %>%
	left_join(mute_votes, by = "vote") %>%
	mutate(ccode = countrycode(country, "country.name", "cown"))
glimpse(joined1)

sum(is.na(joined1$ccode))

# this works for everything exept the Federal Republic of Germany
	# should work for reproducing datacamp
	# should probably not use this datacamp tutorial code directly for additional analysis
missed <- joined1 %>%
	filter(is.na(country_code))

unique(missed$country)
sum(joined$country == "Federal Republic of Germany")

# we'll just convert the Federal Republic of Germany to Germany as a shortcut
	# I know...

joined$country[joined$country == "Federal Republic of Germany"] <- "Germany"


joined$country_code[joined$country_code == "GB"]

votes2 <- joined %>%
	left_join(mute_votes, by = "vote") %>%
	mutate(ccode = countrycode(country, "country.name", "cown"))
glimpse(votes2)

votes2 <- votes2[c(1, 5, 13, 14)]
names(votes2) <- c("rcid", "session", "vote", "ccode")




############
# datacamp #
############

# Exploring dplyr

# load the dplyr package
library("dplyr")

# print the votes dataset
print(votes)

# filter for votes that are "yes", "abstain", or "no"
filter(votes, vote <= 3)



# Adding a Year Column

# add another %>% step to add a year column
votes %>%
  filter(vote <= 3) %>%
  mutate(year = session + 1945)



# Adding a Country Column

# load the countrycode package
library("countrycode")

# convert country code 100
countrycode(100, "cown", "country.name")

# add a country column within the mutate: votes_processed
votes_processed <- votes %>%
  filter(vote <= 3) %>%
  mutate(year = session + 1945) %>%
  mutate(country = countrycode(ccode, "cown", "country.name"))

  


# Summarizing the full dataset

# Print votes_processed
print(votes_processed)

# Find total and fraction of "yes" votes
votes_processed %>%
  summarize(total = n(),
  percent_yes = mean(vote == 1))




# Summarizing by Year
  # the summarize() funciton is especially useful because it can be used within groups

# summarize percent yes vote by year
votes_processed %>%
  group_by(year) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))

  # summarize by country: by_country
by_country <- votes_processed %>%
  group_by(country) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))




# Sorting by percentage of "yes" votes
  	# now we want to see which countries voted "yes" the most and least often

# You have the votes summarized by country
by_country <- votes_processed %>%
  group_by(country) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))

# Print the by_country dataset
print(by_country)

# Sort in ascending order of percent_yes
by_country %>%
  arrange(percent_yes)

# Now sort in descending order
by_country %>%
  arrange(desc(percent_yes))



# Filtering summarized output
by_country %>%
  arrange(percent_yes)  %>%
  filter(total > 100)
