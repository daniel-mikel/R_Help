# This is part 1 of a multi part course in datacamp
# https://campus.datacamp.com/courses/arima-modeling-with-r/time-series-data-and-models?ex=1

# companion package astsa which holds data
library("xts")
library("astsa")

# this time series is of Johnson & Johnson's quarterly share earnings
	# has many common features of time series data
		# upward trend
		# seasonality
			# 2nd and 3rd quarters are usually up while 1st and 4rd quarters are down
		# heteroscedasticity
			# as the value of the asset grows small percentage changes become large absolute changes

library("astsa")
plot(jj, main = "Johnson & Johnson Quarterly Earnings per Share", type = "c")
text(jj, labels = 1:4, col = 1:4)

# data on average tempeture deviation from 1880 and 2015
	# largely positive trend
	# no seasonal component
	# homoscedastic

install.packages("astsa")
plot(globtemp, main = "Global Temperature Deviations", type = "o")

# S&P weekly returns data
	# US stock index based on 500 large corperations
	# based on changes per time period
	# no trend or seasonality
	# seems like theres no pattern
		# except once in a while the variance is large

library("xts")
plot(sp500w, main = "S&P 500 Weekly Returns")

# Time Series Regression Models
	

# Auto Regression or AR series
	# Xt = B(Xt-1) + Et (where Et is white noise)
	# Basic assumptions 
		# errors are independent, normal, and homoscedastic
		# in other words, errors are white noise
	# White Noise 
		# independent normals with common variance
		# basic building block of time series
	# with time series we can regress today on yesterday's observations
		# this is called autoregression [self regression]
	# typically the errors in a series are NOT independent
		# usually correlated
		# one way to combat this is to use a Moving Average model, or MA model
	
# Moving Average Model
	# we regress the error term with past error terms
	# Et = Wt + B(Wt-1) 
		# where Wt is white noise in period 't'

# Combining these leads to the ARMA model
	# or autoregression with autocorrelated errors



# Data Play

# View a detailed description of AirPassengers
help(AirPassengers)

# Plot AirPassengers
plot(AirPassengers)

# Plot the DJIA daily closings
plot(djia$Close)

# Plot the Southern Oscillation Index
plot(soi)



# Stationarity and Nonstationarity

# stability refers to:
	# mean constand over time (no trend)
	# the correlation structure remains constant over time

# stationarity means we can use simple averageing to estimate correlation
	# if the mean is constant, then we can estimate it by the sample average
	# if the correlation structure is constant:
		# we can use all pairs of data that are one time unit apart
			# e.g. (x1, x2), (x2, x3), ... for lag 1
			# e.g. (x1, x3), (x2, x4), ... for lag 2
			# this works because the relationship between contiguous values remains the same over time


# the dataset soi - Southern Oscillation Index
	# ocean tempeture
	# highly seasonal
		# positvitely autocorrelated at lag 1 
		# negatively autocorrelated at lag 6 (cold in the winter, hot in the summer)

# trend stationarity
	# stationarity around a trend, differencing still works!

plot(chicken)
plot(diff(chicken))

# nonstationarity in trend and variable
	# if trend and in heteroscadasticity
	# use logs!
		# eliminates heteroscadasticty
		# then differencing it will de-trend it


plot(jj) # trend and heteroscadastic

log_jj <- log(jj)
plot(log_jj) # trend and homoscadastic			

diff_log_jj <- diff(log_jj)
plot(diff_log_jj) # no trend and homoscadastic (no trend in variance or mean!)



# Differencing

# when a time series is trend stationary:
	# it will have stationary behavior around a trend
	# Yt = α + βt + Xt where  Xt is stationary

# another type of model is the random walk
	# Xt = Xt−1 + Wt
		# where Wt is white noise
	# called a random walk because the time 't' process is where it was in time t-1 plus a completely random movement
	# for a random walk with drift, a constant is added to the model and will cause the random walk to drift in the direction (positive or negative) of the drift

# in both cases, differencing removes the trend and 'coerces' stationarity. 
	# difference between the value of a time series at a certain point in time and it's preceding value

# Plot globtemp and detrended globtemp
par(mfrow = c(2,1))
plot(globtemp) 
plot(diff(globtemp))

# Plot cmort and detrended cmort
par(mfrow = c(2,1))
plot(cmort)
plot(diff(cmort))



# Dealing with Trend and Heteroscedasticity

# here we will coerce nonstationary data to stationarity by calculating the growth rate as follows
	# often time series are generated as:
		# Xt = (1 + pt)Xt−1
			# where pt is the interest rate, or return on growth rate

		# Yt = log(Xt) − log(Xt−1) ≈ pt.

# Plot GNP series (gnp) and its growth rate
par(mfrow = c(2,1))
plot(gnp)
plot(diff(log(gnp)))

# Plot DJIA closings (djia$Close) and its returns
par(mfrow = c(2,1))
plot(djia$Close)
plot(diff(log(djia$Close)))



# Stationary Time Series: ARMA

# why is it valid to use ARMA models for stationary series?
	# Wold Decomposition
		# proved that any stationary time series may be represented as a linear combination of white noise
		# Xt = Wt + a1 * Wt-1 + a2* Wt-2 + ...


# generating ARMA using arima.sim()
	# basic syntax
		# arima.sim(model, n, ...)
			# where model is:
				# a list of c(p, d, q)
			# n is the number of observations to replicate
	
# for example, to generate a model MA(1) with Xt = Wt + 0.9*Wt-1
x <- arima.sim(list(order = c(0, 0, 1), ma = 0.9), n = 100)
plot(x)	
	
# genearate an AR(2) by Xt = -0.9*Xt-2 + Wt
y <- arima.sim(list(order = c(1, 0, 0), ar = -0.9), n = 100)
plot(y)


 
 # Simulating ARMA Models

# Generate and plot white noise
WN <- arima.sim(list(order = c(0, 0, 0)), n = 200)
plot(WN)

# Generate and plot an MA(1) with parameter .9 
MA <- arima.sim(list(order = c(0, 0, 1), ma = 0.9), n = 200)
plot(MA)	

# Generate and plot an AR(2) with parameters 1.5 and -.75
AR <- arima.sim(list(order = c(2, 0, 0), ar = c(1.5, -0.75)), n = 200)
plot(AR)

