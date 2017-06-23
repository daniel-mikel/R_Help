# This is part 3 of a multi part course in datacamp
# https://campus.datacamp.com/courses/arima-modeling-with-r/seasonal-arima?ex=1

# companion package astsa which holds data
library("xts")
library("astsa")
library("forecast")

# Pure Seasonal [ARIMA] Models

# we often collect data with known seasonal components


# PACF/ACF of Pure Seasonal Models

# AR(P)s
	# ACF - Tails off at seasonal lags
	# PACF - Cuts off after lag Ps

# MA(Q)s
	# ACF - Cuts off after lag Qs
	# PACF - Tails off at seasonal lags

# ARMA(P,Q)s
	# ACF - Tails off at seasonal lags
	# PACF - Tails off at seasonal lags



# Fit a Pure Seasonal Model

# we generate simulated data with a pure seasonal model given by:
	# Xt = 0.9Xt−12 + Wt + 0.5Wt−12
	# this denotes a SARMA(1,1)S=12 model

# trying to find a way to simulate seasonal arima packages to reproduce but no luck
	# the dataframe was preloaded in the datacamp enviornment
	
# Plot sample P/ACF to lag 60 and compare to the true values
acf2(x, max.lag = 60)

# Fit the seasonal model to x
sarima(x, p = 0, d = 0, q = 0, P = 1, D = 0, Q = 1, S = 12)



# Fit Mixed Seasonal Model

# some seasonal data is purely seasonally dependant
	# where seasonal dependence explans the seasonal trends

# most time series have mixed dependence
	# only some of the variation is explained by seasonal trends

# now we'll use sarima() for a mixed seasonal model
	# here we produce a sarima(0,0,1)x(0,0,1)12 model

# note time series generated in DataCamp

# Plot sample P/ACF pair to lag 60 and compare to actual
acf2(x, max.lag = 60)

# Fit the seasonal model to x
sarima(x, p = 0, d = 0, q = 1, P = 0, D = 0, Q = 1, S = 12)



# Data Analysis - Unemployment I 

# Plot unemp 
plot(unemp)

# Difference your data and plot it
	# notice in acf2 how the differenced data still has seasonal persistance
	# note that fitting the model as is to sarima() is still weak

d_unemp <- diff(unemp)
plot(d_unemp)
acf2(d_unemp, max.lag = 62)
sarima(d_unemp, 0,0,0,0,0,1, S = 12)
sarima(d_unemp, 0,0,1,0,0,1, S = 12)

# Seasonally difference d_unemp and plot it
	# notice the time series now looks more stationary 

dd_unemp <- diff(d_unemp, lag = 12)  
plot(dd_unemp)
acf2(dd_unemp, max.lag = 62)



# Data Analysis - Unemployment II

# note that the lag axis in the sample P/ACF plot is in terms of years
	# thus lags 1, 2, 3... represent year 1 (12 months), year 2 (24 months), etc.
	# 

# Plot P/ACF pair of fully differenced data to lag 60
	# this differences the data, and then differences at lag 12

dd_unemp <- diff(diff(unemp), lag = 12)
acf2(dd_unemp, max.lag = 60)

# Fit an appropriate model
sarima(unemp, 2,1,0,0,1,1, S = 12)




# Data Analysis - Commodity Prices

# if you are interested in further commodity time series:
	# http://www.indexmundi.com/commodities/

# chicken data in library("astsa")

# Plot differenced chicken
plot(chicken)
plot(diff(chicken))

# Plot P/ACF pair of differenced data to lag 60
acf2(diff(chicken), max.lag = 60)

# Fit ARIMA(2,1,0) to chicken - not so good
sarima(chicken, 2, 1, 0)

# Fit SARIMA(2,1,0,1,0,0,12) to chicken - that works
sarima(chicken, 2,1,0,1,0,0,12)



# Data Analysis - Birth Rate

# data for monthly live births
	# in library("astsa")

plot(birth)

# Plot P/ACF to lag 60 of differenced data
d_birth <- diff(birth)
acf2(d_birth, max.lag = 60)

# Plot P/ACF to lag 60 of seasonal differenced data
dd_birth <- diff(d_birth, lag = 12)
acf2(dd_birth, max.lag = 60)

# Fit SARIMA(0,1,1)x(0,1,1)_12. What happens?
sarima(birth, 0, 1, 1, 0, 1, 1, 12)

# Add AR term and conclude
sarima(birth, 1, 1, 1, 0, 1, 1, 12)


# Forecasting Seasonal ARIMA

# like in non-seasonal arima, forecasting in seasonal arima models is easy once a model is chosen
	# because the model describes the dynamics of the time series over time
	# you simply continue the dynamics of the model into the future
	# can still use the sarima.for() model

sarima.for(log(AirPassengers), n.ahead = 24, 0, 1, 1, 0, 1, 1, 12)


# Forecasting Monthly Unmeployment

# Fit your previous model to unemp and check the diagnostics
sarima(unemp, 2,1,0,0,1,1, S = 12)

# Forecast the data 3 years into the future
sarima.for(unemp, n.ahead = 36, 2, 1, 0, 0, 1, 1, 12)



# How Hard Is It to Forecast Commodity Prices

# commodities are notoriously difficult to predict
	# here we try to predict chickens five years into the future
	
# Fit the chicken model again and check diagnostics
sarima(chicken, 2,1,0,1,0,0,12)

# Forecast the chicken data 5 years into the future
sarima.for(chicken, n.ahead = 60, 2,1,0,1,0,0,12)
