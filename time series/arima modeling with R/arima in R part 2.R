# This is part 1 of a multi part course in datacamp
# https://campus.datacamp.com/courses/arima-modeling-with-r/fitting-arma-models?ex=1

# companion package astsa which holds data
library("xts")
library("astsa")



# AR and MA Models
	# how to identify AR and MA models?
	# we've generated AR and MA models below
		# they look pretty similar 
		# can't identify data as AR or MA simply by sight

x <- arima.sim(list(order = c(1, 0, 0), ar = -0.7), n = 200)
y <- arima.sim(list(order = c(0, 0, 1), ma = -0.7), n = 200)

par(mfrow = c(1, 2))
plot(x, main = "AR(1)")
plot(y, main = "MA(1)")

# ACF and PACF
	# AR(p)
		# ACF will tial off
		# PACF cuts off lag p
	# MA(q)
		# ACF cuts off lag q
		# PACF tails off
	# ARMA(p,q)
		# ACF tails off
		# PACF tails off
	# it's not possible for both ACF and PACF to cut off

# here is an AR(2) model
	# in this case:
		# ACF function tails off 
		# PACF cuts off after lag 2

AR2 <- arima.sim(list(order = c(2, 0, 0), ar = c(-0.9, -0.7)), n = 200)

par(mfrow = c(3, 1))
plot(AR2, main = "AR(2)")
acf(AR2, main = "ACF AR(2)")
pacf(AR2, main = "PACF AR(2)")


# here is an MA(1) model
	# in this case:
		# ACF cuts off after lag 1
		# PACF tails off

MA2 <- arima.sim(list(order = c(0, 0, 1), ma = -0.9), n = 200)

par(mfrow = c(3, 1))
plot(MA2, main = "MA(2)")
acf(MA2, main = "ACF MA(2)")
pacf(MA2, main = "PACF MA(2)")

# estimation for ARMA models
	# similar for least squares for regression
	# for time series its much harder, and results are not explicit

# AR(2) with mean 50:
	# Xt = 50 + 1.5(Xt-1 - 50) - 0.75(Xt-2 - 50) + Wt
	# sarima is in library("astsa")
	# note that in ttable:
		# the estimated coefficients are close to the simulated coefficients

x <- arima.sim(list(order = c(2, 0, 0), 
	ar = c(1.5, -0.75)),
	n = 200) + 50

x_fit <- sarima(x, p = 2, d = 0, q = 0)
x_fit$ttable

# MA(1) with mean 0
	# also note that the estimated coefficients are close to the simulated coefficients
	# also, the estimate of the mean is not significantly different from zero

y <- arima.sim(list(order(0, 0, 1),	ma = -0.7), n = 200)

y_fit <- sarima(y, p = 0, d = 0, q = 1)
y_fit$ttable



# Fitting an AR(1) Model

# Generate 100 observations from the AR(1) model
x <- arima.sim(model = list(order = c(1, 0, 0), ar = 0.9), n = 100) 

# Plot the generated data 
plot(x)

# Plot the sample P/ACF pair
	# acf2() is from library("astsa")
		# generates an acf() and pacf() 
acf2(x)

par(mfrow = c(2, 1))
acf(x, main = "ACF x")
pacf(x, main = "PACF x")


# Fit an AR(1) to the data and examine the t-table
	# could also do sarima(x, 1, 0, 0)
	
x_fit <- sarima(x, p = 1, d = 0, q = 0)
x_fit



# Fitting an AR(2) Model

x <- arima.sim(model = list(order = c(2, 0, 0), ar = c(1.5, -.75)), n = 200)

# Plot x
plot(x)

# Plot the sample P/ACF of x
acf2(x)

# Fit an AR(2) to the data and examine the t-table
x_fit <- sarima(x, 1, 0, 0)
x_fit

x_fit2 <- sarima(x, 2, 0, 0)
x_fit2



# Fitting an MA(1) Model

x <- arima.sim(model = list(order = c(0, 0, 1), ma = -0.8), n = 100)

# Plot x
plot(x)

# Plot the sample P/ACF of x
acf2(x)

# Fit an MA(1) to the data and examine the t-table
x_fit <- sarima(x, 0, 0, 1)
x_fit



# AR and MA Together

# now we put the AR and ARMA model together for the ARMA model
	# Xt = B*Xt-1 + Wt + B2*Wt-1
	# think of it as autoregression with correlated errors 

# acf and pacf in ARMA
	# in ARMA series, both the acf and pacf tail off
		# done below, pacf also tails off, its values drop of extrememly quickly
	# NOTE you can't tell the order of a model by its acf() and pacf(), just what type (ARMA vs. AR vs. MA) of model it is

x <- arima.sim(model = list(order = c(1, 0, 1), 
	ar = 0.9,
	ma = -0.4),
	n = 100)

par(mfrow = c(2, 1))
acf(x, main = "ACF x")
pacf(x, main = "PACF x")

# estimation of ARMA models
	# simliar to AR and MA models
	# shown below

x_fit <- sarima(x, 1, 0, 1)





# Fitting an ARMA model

# here we merge an AR and MA model into an ARMA model
	# we'll generate an ARMA(2,1) model
	# Xt=Xt−1 − 0.9Xt−2 + Wt + 0.8Wt−1

x <- arima.sim(model = list(order = c(2, 0, 1),
	ar = c(1, -0.9),
	ma = 0.8),
	n = 250)

par(mfrow = c(2, 1))
acf(x)
pacf(x)

# Plot x
plot(x)

# Plot the sample P/ACF of x
	# acf2() handy
	# could still use above with par(mfrow())
acf2(x)


# Fit an ARMA(2,1) to the data and examine the t-table

x_fit_1_0 <- sarima(x, 1, 0, 0) # terrible acf and ljung-box
x_fit_0_1 <- sarima(x, 0, 0, 1) # terrible acf and ljung-box
x_fit_1_1 <- sarima(x, 1, 0, 1) # terrible acf and ljung-box

x_fit_2_0 <- sarima(x, 2, 0, 0) # terrible acf and ljung-box
x_fit_0_2 <- sarima(x, 0, 0, 2) # terrible acf and ljung-box


x_fit_2_1 <- sarima(x, 2, 0, 1) # acf looks good, ljung-box looks good
x_fit_1_2 <- sarima(x, 1, 0, 2) # terrible acf and ljung-box

x_fit_2_2 <- sarima(x, 2, 0, 2) # terrible acf and ljung-box


# Model Choice and Residual Analysis

# its often the case that 2 or more models seem reasonable
	# in general its good to fit a few models before deciding on the best one

# the two most popular methods for chosing the right model are:
	# AIC
		# Akaike Information Criterion
		# wikipedia:
			# measures the quality of each model, relative to each of the other models
				# means of model selection
			# offers a relative estimate of the information lost when a given model is used to represent the process that generates the data
			# it deals with the trade-off between the goodness of fit of the model and the complexity of the model
			# does not test in the sense of testing a null hypothesis
			# can tell nothing about the quality of a model in the absolute sense
				# if all the candidate models fit poorly, AIC will not give any warning of that
	# BIC
		# Baysian Information Criterion
			# sometimes Schwarz criterion (SBC or SBIC)
		# wikipedia
			# the model with the lowest BIC is prefered
				# closely related to the AIC
			# when fitting models, it is possible to increase the likelihood by adding arameters
				# but doing so may result in overfitting
				# thus, penalty term for number of parameters
					# as with AIC 
	# both penalize for the number of parameters
		# BIC has a bigger penalty

# we work with the GNP data
	# recall that growth rate can be calculated by taking a difference of the logs of the data
	# two models were fitted to the data
		# an AR(1) and an MA(2)
		# note that AIC prefers MA(2) and the BIC prefers the AR(1)
			# and since AR(1) is a simpler model, it would be appropriate to prefer that to the MA(2)

gnpgr <- diff(log(gnp))
plot(gnpgr)
sarima(gnpgr, p = 1, d = 0, q = 0) # $AIC = -8.2944, $BIC = -9.26374
sarima(gnpgr, p = 0, d = 0, q = 2) # $AIC = -8.2977, $BIC = -9.25712 

# Resigual Analysis
	# same as in linear regression
		# we want to make sure the residuals are white noise (white gaussian noise)
	# if not, then we haven't found the best model
	# sarima() can be used to check models for regression analysis
		# Standardized Residual Plot
			# hard to tell if a plot is of white noise
			# easier to tell if there are non-white noise patterns
		# ACF of the residuals
			# can be used to asses whiteness
			# 95% of the values should be between the blue dashed lines
		# Normal Q-Q plot
			# assesses normality
			# if the residuals are normal the points will line up with the line
				# there are often extreme values on the ends
			# as long as there's no large departures from the line, then the normal assumption is reasonable
		# Q-Statistic p-values
			# tests for whiteness in the residuals
			# if most points are above the blue dashed line (0.05) then you can safely assume the noise is white
			# if many of the points are below the line:
				# then there's still some correlation left in the residuals
				# you should try to fit another model or add a parameter



# Model Choice - I

# the dataframe varve is in library("astsa")
dl_varve <- diff(log(varve))

# Fit an MA(1) to dl_varve.
	# AIC = -0.4406366
	# BIC = -1.426575

sarima(dl_varve, 0, 0, 1)

# Fit an MA(2) to dl_varve. Improvement?
	# AIC = -0.4629629
	# BIC = -1.441871

sarima(dl_varve, 0, 0, 2)

# Fit an ARMA(1,1) to dl_varve. Improvement?
	# AIC = -0.467376
	# BIC = -1.446284

sarima(dl_varve, 1, 0, 1)

# in the end, AIC and BIC are both less for MA(1)
	# MA(1) is the preferred model choice



# Residual Analysis

dl_varve <- diff(log(varve))

# Fit an MA(1) to dl_varve. Examine the residuals 
	# acf looks goodish, Ljung-Box is not happy
sarima(dl_varve, 0, 0, 1)

# Fit an ARMA(1,1) to dl_varve. Examine the residuals
	# everything looks good, Ljung-Box is happy
sarima(dl_varve, 1, 0, 1)




# Arma Get In

# the dataframe oil
	# WTI spot price FOB (in dollars per barel)
	# weekly price from 2000 to 2008

# Calculate approximate oil returns
oil_returns <- diff(log(oil))

# Plot oil_returns. Notice the outliers.
plot(oil_returns)

# Plot the P/ACF pair for oil_returns
acf2(oil_returns)

# Assuming both P/ACF are tailing, fit a model to oil_returns
sarima(oil_returns, 1, 0, 1)
