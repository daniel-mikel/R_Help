# Time Series Analysis (Part 5)
# https://campus.datacamp.com/courses/introduction-to-time-series-analysis/a-simple-moving-average?ex=1


# The Simple Moving Average Model

# models with autocorrelation can be constructed from white noise
	# a weighted sum of current and previous noise is called a simple moving average process
	# there are many Moving Average (MA) processes
		# we'll focus on the simplest first order case
	# Today = Mean + Noise + Slope * (Yesterday's Noise)
	# or Yt = m + Et + B*(Et-1)
		# where Et or Noise is mean zero white noise
		# if the slope, or B, is zero, then this is simply a white noise process
			# then process Yt is autocorrelated
		# large values of B lead to greater autocorrelation
		# negative values of B result in oscillatory time series



# Simulate the Simple Moving Average Model

# MA model is used to account for very short-run autocorrelation 
	# where each observation is regressed on the previous innovation
	# like the AR model, the MA model includes the WN model as a special case

# we can use arima.sim() to simulate MA model
	# set argument to 'list(ma = theta)' where theta is the slope parameter 
		# slope parameter of the interval [-1,1]
	# the 'n' argument specifies the length of the series

# Generate MA model with slope 0.5
x <- arima.sim(model = list(ma = 0.5), n = 100)

# Generate MA model with slope 0.9
y <- arima.sim(model = list(ma = 0.9), n = 100)

# Generate MA model with slope -0.5
z <- arima.sim(model = list(ma = -0.5), n = 100)

# Plot all three models together
plot.ts(cbind( x, y, z))



# Estimate the Autocorrelation function (ACF) for a moving average

# you can use acf() to generate plots of the autocorrelation within MA data

# Calculate ACF for x
acf(x)

# Calculate ACF for y
acf(y)

# Calculate ACF for z
acf(z)



# MA Model Estimation and Forecasting

# applying MA processes to inflation data

data(Mishkin, package = "Ecdat")
inflation <- as.ts(Mishkin[, 1])
inflation_changes <- diff(inflation)
ts.plot(inflation) 
ts.plot(inflation_changes)

# understanding the inflation data
	# the observations in the inflation data wandered around
	# changes in the inflation rate were quickly mean reverting to 0

acf(inflation_changes, lag.max = 24)

# above we see a strong, negative autocorrelation at lag 1
	# while the autocorrelations at lags 2 through 24 are all near 0 
	# implying that the MA model may be a good fit for this model

MA_inflation_changes <- arima(inflation_changes, order = c(0,0,1))
print(MA_inflation_changes)

# above we set the 'order' argument to order = c(0, 0, 1) to indicate a first order MA model
	# summary saved in MA_inflation_changes
	# B or slope of the MA model is -0.7932
	# m or mean is 0.0010
	# sigma^2 of 8.882

ts.plot(inflation_changes)
MA_inflation_changes_fitted <- inflation_changes - residuals(MA_inflation_changes)
points(MA_inflation_changes_fitted, type = "l", col = "red", lty = 2)

# above we can see that the MA model explains a lot of the variation of the series

# forecasting
predict(MA_inflation_changes)
predict(MA_inflation_changes, n.ahead = 6)



# Estimate the Simple Moving Average Model

# Fit the MA model to x
arima(Nile, order = c(0, 0, 1))

# Paste the slope (ma1) estimate below
0.3783

# Paste the slope mean (intercept) estimate below
919.2433

# Paste the innovation variance (sigma^2) estimate below
23272

# Fit the MA model to Nile
MA <- arima(Nile, order = c(0, 0, 1))
print(MA)

# Plot Nile and MA_fit 
	# below resid() is used instead of residuals(), the two functions seem itentical
		# resid(MA) - residuals(MA) yielded a vector of 0's
ts.plot(Nile)
MA_fit <- Nile - resid(MA)
points(MA_fit, type = "l", col = 2, lty = 2)


# Simple Forecasts from an Estimated MA Model

# Make a 1-step forecast based on MA
predict_MA <- predict(MA)

# Obtain the 1-step forecast using $pred[1]
predict_MA$pred[1]

# Make a 1-step through 10-step forecast based on MA
predict_MA <- predict(MA, n.ahead = 10)

# Plot the Nile series plus the forecast and 95% prediction intervals
ts.plot(Nile, xlim = c(1871, 1980))
MA_forecasts <- predict(MA, n.ahead = 10)$pred
MA_forecast_se <- predict(MA, n.ahead = 10)$se
points(MA_forecasts, type = "l", col = 2)
points(MA_forecasts - 2*MA_forecast_se, type = "l", col = 2, lty = 2)
points(MA_forecasts + 2*MA_forecast_se, type = "l", col = 2, lty = 2)



# Compare the AR and MA Models

# AR and MA are similar in many ways
	# both have a mean zero white noise paramenter, with a varence parameter sigma^2
	# both have a mean parameter

# in the MA model
	# today's observations are regressed on yesterday's noise

# in the AR model
	# today's observations are regressed on yesterdays observation Yt(Yt-1)

# however, MA only has autocorrelation at one lag
	# while the AR function has autocorrelation at many lags




# MA vs MA models

# how can we determine whether an AR or MA model is more appropriate in practice?

# we use two different measure to determine model fit
	# the Akaike Information Criterion (AIC)
	# the Bayesian Information Criterion (BIC)

# AIC and BIC
	# mathmatically beyond this course
	# both indicators penalize models with more estimated paramenters 
		# to avoid overfitting
	# smaller values are preferred
	# all else being equal, a model that produces a lower AIC or BIC than another model is considered a better fit
	# in R these functions are:
		# AIC()
		# BIC()


# NOTE we want AR and MA and AR_fit and MA_fit to both be defined
	# to plot we will need AR_fit and MA_fit to see and compare the series
	# for AIC() and BIC() we neeed the AR and MA summaries

AR <- arima(Nile, order = c(1, 0, 0))
MA <- arima(Nile, order = c(0, 0, 1))

AR_fit <- Nile - resid(AR)
MA_fit <- Nile - resid(MA)

# Find correlation between AR_fit and MA_fit
cor(AR_fit, MA_fit)

# Find AIC of AR
AIC(AR)

# Find AIC of MA
AIC(MA)

# Find BIC of AR
BIC(AR)

# Find BIC of MA
BIC(MA)
