# Time Series Analysis (Part 1)
# these are the notes from a datacamp tutorial found:
	# https://campus.datacamp.com/courses/introduction-to-time-series-analysis/exploratory-time-series-data-analysis?ex=2


# Exploring Raw Time Series
	# we'll start by learning some functions to explore datasets

# Print the Nile dataset
print(Nile)

# List the number of observations in the Nile dataset
length(Nile)

# Display the first 10 elements of the Nile dataset
head(Nile, n = 10)

# Display the last 12 elements of the Nile dataset
tail(Nile, n = 12)


# Basic Time Series Plots

# Plot the Nile data
plot(Nile)

# Plot the Nile data with xlab and ylab arguments
plot(Nile, xlab = "Year", ylab = "River Volume (1e9 m{3}")

# Plot the Nile data with xlab, ylab, main, and type arguments
	# type = "l" just plots the line of the series
	# type = "b" plots both the line graph and the observed points at each year
plot(Nile, xlab = "Year", ylab = "River Volume (1e9 m{3})", main = "Annual River Nile Volume at Aswan, 1871 - 1970", type="b")


# What does the Time Index Tell Us?
	# not sure which package (if any) holds the dataframes used in this section
	# the data in this section the data is not spaced out evenly over time
		#  the first, second, and last observations are at times 1.210322, 1.746137, and 20.180524 instead of 1,2, and 20

# Plot the continuous_series using continuous time indexing
par(mfrow=c(2,1))
plot(continuous_time_index, continuous_series, type = "b")

# Make a discrete time index using 1:20 
discrete_time_index <- 1:20

# Now plot the continuous_series using discrete time indexing
plot(discrete_time_index, continuous_series, type = "b")


# Sampling Frequency
	# some times series data is exactly evenly spaced
	# some is only somewhat frequently spaced
	# some is somewhat evenly spaced with missing data points

# Basic assumtions
	# consequtive observations are equally spaced
	# apply a discrete time observation index


# Identifying the Sampling Frequency

# in addition to viewing your data and plotting over time, there are several additional operations that can be performed on time series datasets
	# start() and end() returns the time index of the first and last observations respectivly
	# time() calculates a vector of time indicies, with one element for each time index on which the series was observed
	# deltat() returns the fixed time interval between observations
	# frequency() returns the number of ovservations per unit of time
	# cycle() returns the position in the cycle of each observation

# here we will work with the AirPassengers dataset
	# reports the monthly total international air passengers (in thousands) from 1949 to 1960

# Plot AirPassengers
plot(AirPassengers)

# View the start and end dates of AirPassengers
start(AirPassengers)
end(AirPassengers)

# Use time(), deltat(), frequency(), and cycle() with AirPassengers 
time(AirPassengers)
deltat(AirPassengers)
frequency(AirPassengers)
cycle(AirPassengers)


# Missing Values

# Plot the AirPassengers data
plot(AirPassengers)

# Compute the mean of AirPassengers
	# in datacamp, some values of AirPassengers have been removed
		# hence why they need the na.rm = TRUE argument
mean(AirPassengers, na.rm = TRUE)

# Impute mean values to NA in AirPassengers
AirPassengers[85:96] <- mean(AirPassengers, na.rm = TRUE)

# Generate another plot of AirPassengers
plot(AirPassengers)

# Add the complete AirPassengers data to your plot
	# not sure what any of this does honestly
rm(AirPassengers)
points(AirPassengers, type = "l", col = 2, lty = 3)


# Building ts() Objects - I

# start with a vector of data
	# apply the ts() object 
		# data in ts() functions are usually approximatly evenly spaced over time

data_vector <- c(10, 6, 11, 8, 10, 3, 6, 9)

# makes data_vector into a time series object
time_series <- ts(data_vector) 

# when plotting a ts() object, Time is automatically added to the horizontal axis
	# by default R uses a simple observation index starting from 1 as the first observation
plot(time_series) 

# specify the start date and observation frequency
	# frequency is the number of observations in each period
		# frequency = 2 would have 2 frequencies for 2001, before moving to 2002, or two observations a year
time_series <- ts(data_vector, start = 2001, frequency = 1)
plot(time_series)

time_series <- ts(data_vector, start = 2001, frequency = 2)
plot(time_series)

# is.ts()
	# checks whether given object is a time series
is.ts(data_vector)
is.ts(time_series)

# why use ts() objects?
	# improved plotting
	# access to time index information
	# model estimation and forecasting (later chapters)


# Creating a Time Series Object with ts()

# a time series vector is a univariate or multivariate (matrix) with additional attributes
	# attributes include:
		# indices for each observations
		# sampling frequency 
		# time increment between observations
	# many methods are avaialbel for utilizing time series attributes
		# plot() on a 'ts' object will automatically generate a plot over time
data_vector <- rnorm(1:48)
plot(data_vector)

time_series <- ts(data_vector, start = 2004, frequency = 4)
# print() handles 'ts' objects differently by attribute

print(time_series)
plot(time_series)


# Testing whether an object is a time series

# Check whether data_vector and time_series are ts objects
is.ts(data_vector)
is.ts(time_series)

# Check whether Nile is a ts object
is.ts(Nile)

# Check whether AirPassengers is a ts object
is.ts(AirPassengers)


# Plotting a Time Series Object

# Check whether eu_stocks is a ts object
eu_stocks <- EuStockMarkets
is.ts(eu_stocks)

# View the start, end, and frequency of eu_stocks
start(eu_stocks)
end(eu_stocks)
frequency(eu_stocks)

# Generate a simple plot of eu_stocks
plot(eu_stocks)
ts.plot(eu_stocks)

# Use ts.plot with eu_stocks
ts.plot(eu_stocks, col = 1:4, xlab = "Year", ylab = "Index Value", main = "Major European Stock Indices, 1991-1998")

# Add a legend to your ts.plot
legend("topleft", colnames(eu_stocks), lty = 1, col = 1:4, bty = "n")



# Plotting a Time Series Object

# Check whether eu_stocks is a ts object
is.ts(eu_stocks)

# View the start, end, and frequency of eu_stocks
start(eu_stocks)
end(eu_stocks)
frequency(eu_stocks)

# Generate a simple plot of eu_stocks
plot(eu_stocks)
ts.plot(eu_stocks)

# Use ts.plot with eu_stocks
ts.plot(eu_stocks, col = 1:4, xlab = "Year", ylab = "Index Value", main = "Major European Stock Indices, 1991-1998")

# Add a legend to your ts.plot
legend("topleft", colnames(eu_stocks), lty = 1, col = 1:4, bty = "n")


