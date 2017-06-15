# Time Series Analysis (Part 4)
# https://campus.datacamp.com/courses/introduction-to-time-series-analysis/autoregression?ex=1


# The Autoregressive Model

# the autoregressive (AR) recursion:
	# Today = Constant + Slope * Yesterday + Noise

# in R (or in this course) we work with the mean centered version of the model:
	# (Today - Mean) = Slope * (Yesterday - Mean) + Noise

# more formally
	# if Et is a white noise (WN) process
	# Yt - m =  B(Yt-1 - m) + Et
		# is then a autoregressive (AR) process
		# where:
			# m is the mean (mew)
			# sigma^2 the variance of the white noise
			# B is the slope coeffecient
				# if slobe B = 0, then:
					# Yt = m + Et
					# or simply a white noise process
					# or written Yt is white noise (m, sigma^2)
				# if slope B != 0
					# then Y depends on both Et and Yt-1 (the white noise AND the previous observation)
					# the process Yt is autocorrelated
				# large values of the slope B lead to greater autocorrelation
				# negative values of the slope B lead to oscillatory time series
		# if m = 0 and B = 1, then:
			# Yt  = Yt-1 + Et
			# which is:
				# Today = Yesterday + Noise
			# but this is a random walk (RW)
			# and Yt is NOT stationary in this case


# Simulate the Autoregressive Model

# the AR model is arguable the most widely used time series model
	# it shares a familiar interpretation of a simple linear regression
	# but each observation is regressed on the previous observation
	# the AR model includes the white noise model (WN) and the random walk (RW) models
	
# arima.sim() can be used to simulate data from an AR model 
	# by setting the model argument equal to list(ar = phi)
		# where phi is a slope parameter from the interval (-1,1)
		# we also need to specify a series length n

# here we will use the arima.sim() to simulate and plot three different AR models

# Simulate an AR model with 0.5 slope
x <- arima.sim(model = list(ar = 0.5), n = 100)

# Simulate an AR model with 0.9 slope
y <- arima.sim(model = list(ar = 0.9), n = 100)

# Simulate an AR model with -0.75 slope
z <- arima.sim(model = list(ar = -0.75), n = 100)

# Plot your simulated data
plot.ts(cbind( x, y, z))


# Estimate the Autocorrelation function (ACF) for an autoregression

# what if you need to estimate the autocorrelation function from your data?
	# use acf()
		# estimates autocorrelation by exploring lags in your data
	# by default, this command generates a plot of the relationship between the currenc observation and the lags extending backwards

# Calculate the ACF for x
acf(x)

# Calculate the ACF for y
acf(y)

# Calculate the ACF for z
acf(z)



# Compare the random walk (RW) and autoregressive (AR) models

# the random walk (RW) model is a special case of the autoregressive (AR) model with a slope parameter of 1
	# recall that the RW is NOT stationary and has strong persistence
	# its sample autocovariance function (ACF) also decays to zero very slowly
		# meaning past values have a long lasting impact on current values

# the stationary AR model has a slope parameter between -1 and 1
	# AR exhibits higher persistence when the slope is closer to 1
		# but its sample ACF also decays to zero at a quick (geometric) rate
			# meaning that values far in the past have little impoact on future values of the process


# Simulate and plot AR model with slope 0.9 
x <- arima.sim(model = list(ar = 0.9), n = 200)
ts.plot(x)
acf(x)

# Simulate and plot AR model with slope 0.98
y <- arima.sim(model = list(ar = 0.98), n = 200)
ts.plot(y)
acf(y)

# Simulate and plot RW model
z <- arima.sim(model = list(order = c(0,1,0)), n = 200)
ts.plot(z)
acf(z)



# AR Model Estimation and Forecasting

# AR Processes: Inflation Rate
	# one-month US inflation rate (in percent, annual rate)
	# monthly observations from 1950 through 1990


data(Mishkin, package = "Ecdat")
inflation <- as.ts(Mishkin[, 1])
ts.plot(inflation)
acf(inflation)

# the inflation data has:
	# strong persistence
	# normally positive values
		# with uptick in the 1970s
	# the acf plot shows
		# strong, positive, but decaying autocorrelation
	# now we apply the AR function with arima()

# we specify ARIMA(1,0,0)
	# this indicates a first order AR model
	# AR_inflation then stores the fitted model
AR_inflation <- arima(inflation, order = c(1,0,0)) 
print(AR_inflation)

# reading the  arima() output
	# ar1 is the slope B is 0.5960
	# the mean or m or intercept is 3.9745 sigma^2 as 9.713
	# the white noise

# AR fitted values:
	# mean(Today) = mean(Mean) + mean(Slope) * (Yesterday - mean(Mean))
		# Yt = m + B(Yt-1 - m)
	# Residuals = Today - mean(Today)

# we can plot the observed values with ts.plot(inflation)
	# then we can plot the modeled values by subtracting the residuals of the arima() model at each point in the time series to get the arima model plotted over the ts.plot()
	# make sure not to close 


AR_inflation_fitted <- inflation - residuals(AR_inflation)

ts.plot(inflation)
points(AR_inflation_fitted, type = "l", col = "red", lty = 2)

# Forecasting
	# can use predict() to forecast the next observation[s] in a series

# forecast one observation ahead
predict(AR_inflation)

# forecast 6 observations ahead
predict(AR_inflation, n.ahead = 6) 



#Estimate the Autoregressive (AR) Model

# for a given time series x we can fit the AR model using arima()
	# order = c(1, 0, 0) specifies the 1st order AR 

# Fit the AR model to x
arima(AirPassengers, order = c(1, 0, 0))

# Copy and paste the slope (ar1) estimate
0.9646

# Copy and paste the slope mean (intercept) estimate
278.4649

# Copy and paste the innovation variance (sigma^2) estimate
1119

# Fit the AR model to AirPassengers
AR <- arima(AirPassengers, order = c(1, 0, 0))
print(AR)

# Run the following commands to plot the series and fitted values
ts.plot(AirPassengers)
AR_fitted <- AirPassengers - residuals(AR)
points(AR_fitted, type = "l", col = 2, lty = 2)



# Simple Forecasts From an Estimated AR Model

# predict() is used for forecasting, and generates an object
	# the $pred value[s] is the forecast
	# the $se value is the standard error of the forecast
	# the argument n.ahead in predict() establishes a forecasting horizon


# Fit an AR model to Nile
AR_fit <-arima(Nile, order  = c(1, 0, 0))
print(AR_fit)

# Use predict() to make a 1-step forecast
predict_AR <- predict(AR_fit)

# Obtain the 1-step forecast using $pred[1]
predict_AR$pred[1]

# Use predict to make 1-step through 10-step forecasts
predict(AR_fit, n.ahead = 10)

# Run to plot the Nile series plus the forecast and 95% prediction intervals
ts.plot(Nile, xlim = c(1871, 1980))
AR_forecast <- predict(AR_fit, n.ahead = 10)$pred
AR_forecast_se <- predict(AR_fit, n.ahead = 10)$se
points(AR_forecast, type = "l", col = 2)
points(AR_forecast - 2*AR_forecast_se, type = "l", col = 2, lty = 2)
points(AR_forecast + 2*AR_forecast_se, type = "l", col = 2, lty = 2)

