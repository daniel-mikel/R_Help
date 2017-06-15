# Time Series Analysis (Part 2)
# https://campus.datacamp.com/courses/introduction-to-time-series-analysis/predicting-the-future?ex=1


# Trend Spotting

# some time series do not exibit any trends
# some types of trends are:
	# linear
	# rapid growth
	# oscilation / sinusoidal
	# variance
		# increasing or decreasing over time

# some transformations are
	# log()
		# can linearize a rapid growth trend
		# also stabilizes a series with increasing variance
			# but only defined for positively valued time series
	# diff()
		# can remove a linear trend
		# produces a differenced series, or a changed series
		# a first difference series will always have one less degree of freedom
	# diff(..., s)
		# seasonal difference transformation can remove periodic trends


# Removing Trends in Variablility via the Logarithmic Transformation
	# note dataframe rapid_growth was not found

# Log rapid_growth
linear_growth <- log(rapid_growth)
  
# Plot linear_growth using ts.plot()
ts.plot(linear_growth) 


# Removing Trends in Level by Differencing
	# dataframe 'z' was not found

# Generate the first difference of z
dz <- diff(z)
  
# Plot dz
ts.plot(dz)

# View the length of z and dz, respectively
length(z)
length(dz)



# Remove Seasonal Trends with Seasonal Differencing

# Generate a diff of x with lag = 4. Save this to dx
dx <- diff(x, lag = 4)
  
# Plot dx
  ts.plot(dx)

# View the length of x and dx, respectively 
length(x)
length(dx)



# The White Noise Model (WN)

# the WN model is the simplest example of a stationary process
	# has a fixed constant:
		# mean
		# varience
		# no correlation over time

# the arima.sim() function can be used to simulate a white noise time series
	# arima stands for:
		# AutoRegressive Integrated Moving Average
	# arima.sim()'s default values are a:
		# mean of 0 
		# varience of 1
WN_1 <- arima.sim(model = list(order = c(0,0,0)), n = 50)
head(WN_1)
ts.plot(WN_1)

# we can change default arima.sim() values by
WN_2 <- arima.sim(model = list(order = c(0,0,0)),
	n = 200,
	mean = 4,
	sd = 2)		

# we can fit or guess a WN model with arima()
	# we estimate the above ts as having
		# intercept, or mean of 4
			# gives a standard error for the mean estimate of 0.28
		# sigma^2 of 4
arima(WN_2, order  = c(0,0,0))

# otherwise we can just use the mean() and var() functions to estimate WN series
mean(WN_2)
var(WN_2)



# Simulate the White Noise Model

# WN models are the basic time series models
	# they are the basis for more elaborate models which we will consider
# ARIMA(p,d,q) has three parts:
	# p - autoregressive order
	# d - order of integration (or differncing)
	# q - moving average order

# Simulate a WN model with list(order = c(0, 0, 0))
white_noise <- arima.sim(model = list(order = c(0,0,0)), 
	n = 100)

# Plot your white_noise data
ts.plot(white_noise)

# Simulate from the WN model with: mean = 100, sd = 10
white_noise_2 <- arima.sim(model = list(order = c(0,0,0)), 
	n = 100, 
	mean = 100, 
	sd = 10)

# Plot your white_noise_2 data
ts.plot(white_noise_2)



# The Random Walk Model (RW)
	# RW is a simple example of a non-stationary process
	# a random walk has:
		# no specified mean or varience
		# strong dependence over time
			# each value is strongly related to it's neighbor
		# its changes DO follow a WN process 

# the random walk is defined recursively
	# Today = Yesterday + Noise
	# Yt = Y(t-1) + Et
	# the Error or Noise is mean zero WN
	# RW only has one parameter: the WN varience sigma^2

# the RW model and drift
	# Today = Constant + Yesterday + Noise
	# Yt = C + Y(t-1) + Et
	# RW with a drift has two paramenters
		# constant c
		# WN varience sigma^2
	# a RW with drift is differenced as a WN with mean of c


# SImulate the Random Walk Model (RW)

# RW is an ARIMA(0,1,0) model
	# the '1' indicates that the model's order of integration is 1

# Generate a RW model using arima.sim()
random_walk <- arima.sim(model = list(order = c(0,1,0)), 
	n = 100)

# Plot random_walk
ts.plot(random_walk)

# Calculate the first difference series
random_walk_diff <- diff(random_walk)

# Plot random_walk_diff
ts.plot(random_walk_diff)



# Simulate the Random Walk with a Drift

# Generate a RW model with a drift uing arima.sim
rw_drift <- arima.sim(model = list(order = c(0,1,0)), 
	n = 100,
	mean = 1)

# Plot rw_drift
ts.plot(rw_drift)

# Calculate the first difference series
rw_drift_diff <- diff(rw_drift)

# Plot rw_drift_diff
ts.plot(rw_drift_diff)



# Estimate the Random Walk Model (RW)

# Difference your random_walk data
rw_diff <- diff(random_walk)

# Plot rw_diff
ts.plot(rw_diff)

# Now fit the WN model to the differenced data
model_wn <- arima(rw_diff, order = c(0,0,0))

# Store the value of the estimated time trend (intercept)
int_wn <- model_wn$coef

# Plot the original random_walk data
ts.plot(random_walk)

# Use abline(0, ...) to add time trend to the figure
abline(0, int_wn)


# Stationarity Processes

# Stationarity
	# Stationary models are parsimonious
	# stationary processes have distributional stability over time

# observed time series
	# fluctuate randomly
	# but behave similarly from one time period to the next
	# i.e. stocks, which have random flucitonations, but whose mean, variance, covariance can be constant over time

# Weak Stationarity
	# a series is a weakly stationary process if:
		# mean of Yt is same (constant) for all t
		# varience of Yt is same (constant) for all t
		# covarience of Yt and Ys is same for all time instances
	# for example, if a process is weakly stationary, then:
		# Cov(Y2, Y5) = Cov(Y7, Y10)
		# or, the covarience between times 2 and 5 are the same as between time 7 and time 10
			# since they are both 3 time units apart

# Stationarity: Why?
	# a stationary process can be modeled with fewer parameters
	# for example:
		# we do not need a different expectation for each Yt
		# rather they all have a common expectation or mean
		# can estimate the mean acurately by the sample mean

# Stationarity: When?
	# many financial time series do not exhibit stationarity, however:
		# changes in the series are often approximately stationary
			# especially after a log() transformation
		# a stationary series should show random oscillation around some fixed level: a phenomenon called mean-reversion

# Are the White Noise Model or the Random Walk Model More Stationary?

# the WN and RW models are very closely related
	# however, RW is always non-stationary, both with and without a drift term

# Use arima.sim() to generate WN data
white_noise <- arima.sim(model = list(order = c(0, 0, 0)),
 n = 100)

# Use cumsum() to convert your WN data to RW
random_walk <- as.ts(cumsum(white_noise))
  
# Use arima.sim() to generate WN drift data
wn_drift <- white_noise <- arima.sim(model = list(order = c(0,1,0)),
	n = 100,
	mean = 0.4)
  
# Use cumsum() to convert your WN drift data to RW
rw_drift <- as.ts(cumsum(wn_drift))

# Plot all four data objects
	# for some reason this isn't plotting the white_noise correctly...
plot.ts(cbind(white_noise, random_walk, wn_drift, rw_drift))

