# This is part 3 of a multi part course in datacamp
# https://campus.datacamp.com/courses/arima-modeling-with-r/arima-models?ex=1

# companion package astsa which holds data
library("xts")
library("astsa")

# ARIMA - Integrated ARMA
	# ARIMA is a diff(ARMA)


# ARIMA Plug and Play
	# Yt = 0.9Yt−1 + Wt
		# where Yt = ∇Xt = Xt − Xt−1
	# simulated as:

x <- arima.sim(model = list(order = c(1, 1, 0), ar = .9), n = 200)

# Plot x
plot(x)

# Plot the P/ACF pair of x
acf2(x)

# Plot the differenced data
plot(diff(x))

# Plot the P/ACF pair of the differenced data
acf2(diff(x))



# GLobal Warming
	# a plot of 'globtemp' shows a random walk
		# however the diff(globtemp) is more promising

plot(globtemp)
plot(diff(globtemp))

# Plot the sample P/ACF pair of the differenced data 
acf2(globtemp)
acf2(diff(globtemp))

# Fit an ARIMA(1,1,1) model to globtemp
sarima(globtemp, 1, 1, 1)

# Fit an ARIMA(0,1,2) model to globtemp. Which model is better?
sarima(globtemp, 0, 1, 2)



# ARIMA Diagnostics

# diagnostics for ARIMA models is no different than for ARMA models

# overfitting
	# once a model seems reasonable
		# add parameter
		# if it makes a difference, change your model

# note: window() takes a subset of a time series

w_oil <- window(oil, end = 2006) 

# an arima(0,1,0) model performs poorly on the subsetted oil series
	# model not significant
		# residual analysis also poor
	# both acf() and pacf() are tailing off
	# now we try an arima(1,1,1)

w_oil_010 <- sarima(w_oil, 0, 1, 0)
w_oil_010$ttable
acf2(w_oil)

# arima(1,1,1)
	# model and parameters are significant
	# residual analysis looks fine too

w_oil_111 <- sarima(w_oil, 1, 1, 1)
w_oil_111$ttable


# what if we add another paremeter, does it make a difference?
	# in each of the following cases, the additional parameter is insignifiant while the original models parameters remain siginificant
	# they also mess up the residual analysis

w_oil_112 <- sarima(w_oil, 1, 1, 2)
w_oil_112$ttable

w_oil_211 <- sarima(w_oil, 2, 1, 1)
w_oil_211$ttable



# Diagnostics - Simulated Overfitting

# one way to check an analysis is to overfit the model by adding an extra parameter to see if it makes a differnce in the results
	# if adding a parameter changes the results drastically, then you should rethink your model

x <- arima.sim(model = list(order = c(0, 1, 1), ma = .9), n = 250)

# Plot sample P/ACF pair of the differenced data
acf2(diff(x))

# Fit the first model, compare parameters, check diagnostics
x011 <- sarima(x, 0, 1, 1)
x011$ttable
x011$AIC
x011$BIC

# Fit the second model and compare fit
x012 <- sarima(x, 0, 1, 2)
x012$ttable
x012$AIC
x012$BIC




# Diagnostics - Global Tempetatures

# Fit ARIMA(0,1,2) to globtemp and check diagnostics  
globtemp012 <- sarima(globtemp, 0, 1, 2)
globtemp012$ttable
globtemp012$AIC
globtemp012$BIC

# Fit ARIMA(1,1,1) to globtemp and check diagnostics
globtemp111 <- sarima(globtemp, 1, 1, 1)
globtemp111$ttable
globtemp111$AIC
globtemp111$BIC

# Which is the better model?
	# both models and parameters are significant
	# scores lower AIC and BIC, so arima(0,1,2)
"ARIMA(0,1,2)"


# Forecasting ARIMA

# once a model is chosen, forecasting is easy
	# the model already describes how the series behaves over time
	# forecasting simply continues the behavior into the future

# forecasting in library("astsa")
	# sarima.for()
		# for forcasting
		# similar to sarima() but you also specify the forecasting horizon

# sarima.for() is shown on the oil data
	# note calling astsa::oil for the x argument calls the dataframe from the original package
	# the n.ahead in the sarima.for() package specifies the number of time periods you want to forecast ahead
		# in this case, 52 is 52 weeks, or one year 
	# sarima.for() plots the forcast and the standard errors

oil <- window(astsa::oil, end = 2006)
oilf <- window(astsa::oil, end = 2007)
sarima.for(oil, n.ahead = 52, 1, 1, 1)
lines(oilf)



# Forecasting Simulated ARIMA
y <- arima.sim(model = list(order = c(1, 1, 0), ar = .9), n = 120)
x <- window(y, end = 100)

# Plot P/ACF pair of differenced data 
acf2(x)
acf2(diff(x))

# Fit model - check t-table and diagnostics
xfit <- sarima(x, 1, 1, 0)
xfit$ttable
xfit$AIC
xfit$BIC

# Forecast the data 20 time periods ahead
sarima.for(x, n.ahead = 20, p = 1, d = 1, q = 0) 
lines(y)  

 

# Forecasting GLobal Tempetures

# Fit an ARIMA(0,1,2) to globtemp and check the fit
globtemp.fit <- sarima(globtemp, 0, 1, 2)
globtemp.fit$ttable

# Forecast data 35 years into the future
 sarima.for(globtemp, n.ahead = 35, 0, 1, 2)
