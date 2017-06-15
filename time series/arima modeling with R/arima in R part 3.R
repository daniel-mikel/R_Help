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