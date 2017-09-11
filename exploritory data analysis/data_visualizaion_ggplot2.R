# part 2 

library("ggplot2")

# Plotting a line over time

# Define by_year
by_year <- votes_processed %>%
  group_by(year) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))

# Load the ggplot2 package
library("ggplot2")

# Create line plot
ggplot(by_year, aes(x = year, y = percent_yes)) + 
  geom_line()

# Change to scatter plot and add smoothing curve
ggplot(by_year, aes(year, percent_yes)) +
  geom_point()

# Change to scatter plot and add smoothing curve
ggplot(by_year, aes(year, percent_yes)) +
  geom_point() +
  geom_smooth()



# Summarizing by Year and Country

# Group by year and country: by_year_country
by_year_country <- votes_processed %>%
  group_by(year, country) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))

# Start with by_year_country dataset
by_year_country <- votes_processed %>%
  group_by(year, country) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))


# plotting just the UK over time

# Print by_year_country
print(by_year_country)

# Create a filtered version: UK_by_year
UK_by_year <- by_year_country %>%
  filter(country == "United Kingdom of Great Britain and Northern Ireland")

# Line plot of percent_yes over time for UK only
ggplot(UK_by_year, aes(x = year, y = percent_yes)) +
  geom_line()


# Plotting multiple countries

 # Line plot of % yes in four countries
# Vector of four countries to examine
countries <- c("United States of America", "United Kingdom of Great Britain and Northern Ireland",
               "France", "India")

# Filter by_year_country: filtered_4_countries
filtered_4_countries <- by_year_country %>%
  filter(country %in% countries)

# Line plot of % yes in four countries
ggplot(filtered_4_countries, aes(x = year, y = percent_yes, color = country)) + 
  geom_line()



# Faceting
  # colors in the countries can get a little crowded with lots of colored lines
  # faceting plots a matrix of graphs


# Vector of six countries to examine
countries <- c("United States of America", "United Kingdom of Great Britain and Northern Ireland",
               "France", "Japan", "Brazil", "India")

# Filtered by_year_country: filtered_6_countries
filtered_6_countries <- by_year_country %>%
  filter(country %in% countries)

# Line plot of % yes over time faceted by country
ggplot(filtered_6_countries, aes(year, percent_yes)) +
  geom_line() +
  facet_wrap(~ country, scales = "free_y")


# Add three more countries to this list
countries <- c("United States of America", "United Kingdom of Great Britain and Northern Ireland",
               "Russian Federation", "Cuba", "Brazil", "India", "Belgium", "Switzerland", "Rwanda")

# Filtered by_year_country: filtered_countries
filtered_countries <- by_year_country %>%
  filter(country %in% countries)

# Line plot of % yes over time faceted by country
ggplot(filtered_countries, aes(year, percent_yes)) +
  geom_line() +
  facet_wrap(~ country, scales = "free_y")