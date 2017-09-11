# part 3

library("broom")
library("tidyr")
library("purrr")

# Percentage of yes votes from the US by year: US_by_year
US_by_year <- by_year_country %>%
  filter(country == "United States of America")

# Print the US_by_year data
print(US_by_year)

# Perform a linear regression of percent_yes by year: US_fit
US_fit <- lm(percent_yes ~ year, data = US_by_year)

# Perform summary() on the US_fit object
summary(US_fit)


# Load the broom package
library("broom")

# Call the tidy() function on the US_fit object
tidy(US_fit)


# Linear regression of percent_yes by year for US
US_by_year <- by_year_country %>%
  filter(country == "United States of America")
US_fit <- lm(percent_yes ~ year, US_by_year)

# Fit model for the United Kingdom
UK_by_year <- by_year_country %>%
  filter(country == "United Kingdom of Great Britain and Northern Ireland")
UK_fit <- lm(percent_yes ~ year, UK_by_year)

# Create US_tidied and UK_tidied
US_tidied <- tidy(US_fit)
UK_tidied <- tidy(UK_fit)

# Combine the two tidied models
bind_rows(US_tidied, UK_tidied)



# Nesting for Multiple Models
	# I think the '-' in nest() allows it to work with a character vector
	# this returns a list of dataframes (tibbles)
nested <- by_year_country %>%
	nest(-country)

View(nested)

# Print the nested data for Brazil
nested$data[[7]]

# Unnest the data column to return it to its original form
unnest(nested)

# Perform a linear regression on each item in the data column
	# this isn't working... =(
nested <- by_year_country %>%
	nest(-country) %>%
	mutate(model = map(data, ~ lm(percent_yes ~ year, data = .)))


 