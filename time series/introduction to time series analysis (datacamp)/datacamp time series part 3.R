# Time Series Analysis (Part 3)
# https://campus.datacamp.com/courses/introduction-to-time-series-analysis/correlation-analysis-and-the-autocorrelation-function?ex=1


# Scatterplots

# lets consider two hypothetical stocks:
	#

# plot two stocks as a time series
ts.plot(cbind(stock_a, stock_b))

# plot as a scatterplot of stock a vs stock b
plot(stock_a, stock_b)

# log returns for stock a and stock b
stock_a_logreturn = diff(log(stock_a))
stock_b_logreturn = diff(log(stock_b))
ts.plot(cbind(stock_a_logreturn, stock_b_logreturn))

plot(stock_a_logreturn, stock_b_logreturn)



# Asset Prices vs Asset Returns
	# financial asset returns measure changes in price as a fraction of the initial price over a given time horizon
	# let's consider the eu_stocks dataset
	# log returns, also called continuously compounded returns, or equivelently, the changes in the logarithm of prices
		# one advantage of usnig log returns is that calculating multi-period returns from indicidual periods is greatly simplified, you can just add them together!

# Plot eu_stocks
eu_stocks <- EuStockMarkets
plot(eu_stocks)

# Use this code to convert prices to returns
returns <- eu_stocks[-1,] / eu_stocks[-1860,] - 1

# Convert returns to ts
returns <- ts(returns, start = c(1991, 130), frequency = 260)

# Plot returns
plot(returns)

# Use this code to convert prices to log returns
logreturns <- diff(log(eu_stocks))

# Plot logreturns
plot(logreturns)



# Characteristics of Financial Time Series
	# daily financial asset returns typically share many charecteristics
		# returns over one day are typically small
		# their average is close to zero
		# the variance is relatively large
	# over the course of years, several very large returns (in magnitude) are typically observed
		# these outliers happen on only a handfull of days, but account for substantial movement in asset prices
		# because of extremem returns, the distribution of daily asset returns is not normal, but heavy-tailed and sometimes skewed
		# individual returns typically have even greater variablility and more extreme observations than index returns

eu_percentreturns <- returns * 100

# Generate means from eu_percentreturns
colMeans(eu_percentreturns)

# Use apply to calculate sample variance from eu_percentreturns
apply(eu_percentreturns, MARGIN = 2, FUN = var)

# Use apply to calculate standard deviation from eu_percentreturns
apply(eu_percentreturns, MARGIN = 2, FUN = sd)

# Display a histogram of percent returns for each index
par(mfrow = c(2,2))
apply(eu_percentreturns, MARGIN = 2, FUN = hist, main = "", xlab = "Percentage Return")

# Display normal quantile plots of percent returns for each index
par(mfrow = c(2,2))
apply(eu_percentreturns, MARGIN = 2, FUN = qqnorm, main = "")
qqline(eu_percentreturns)


# Plotting Pairs of data

# eu_stocks has the daily closing prices from 1991 - 1998 for the major stock indicies in 
	# Germany (DAX)
	# Switzerland (SMI)
	# France (CAC)
	# UK (FTSE)  

# It is also useful to examine the bivariate relationship between pairs of time series. 
	# matching observations that occur at the same time, between pairs of index values as well as their log returns
	# plot(a,b) function will produce a scatterplot

eu_stocks_df <- as.data.frame(eu_stocks)

# Make a scatterplot of DAX and FTSE
with(eu_stocks_df, plot(DAX, FTSE))

# Make a scatterplot matrix of eu_stocks
pairs(eu_stocks)

# Convert eu_stocks to log returns
logreturns <- diff(log(eu_stocks))

# Plot logreturns
plot(logreturns)

# Make a scatterplot matrix of logreturns
pairs(logreturns)


# Covariance and Correlation

# we can use mean() and sd() to see the charecteristics of a time series
# we can use the cov() function to estimate the covariance of two series
	# a positive covariance implies a positive association between two series
	# covarience depends on the scales of the variables
# correlations are a standardized version of covariance
	# they do not depend on the scales of the variables
	# always between 1 and -1
		# +1 is a perfect positive linear relationship between two variables
		# -1 is a perfect negative linear relationship
		# 0 means there is no linear association
	# we apply the cor() function 
	# could also to cor(A, B)/sd(A) + sd(B)


# Calculating Sample Covariances and Correlations

# sample covariances measure the strength of the linear relationship between matched pairs of variables
	# cov() function calculates covariance for both variables and matrixes

# covariances are very important (especially in finance) 
	# however, they are not scale free
	# can be difficult to directly interpret
	# cor() can be applied to both pairs of variables and matrixes

logreturns_df <- as.data.frame(logreturns)
DAX_logreturns <- as.ts(logreturns_df$DAX)
FTSE_logreturns <- as.ts(logreturns_df$FTSE)

# Use cov() with DAX_logreturns and FTSE_logreturns	
cov(DAX_logreturns, FTSE_logreturns)

# Use cov() with logreturns
cov(logreturns)

# Use cor() with DAX_logreturns and FTSE_logreturns
cor(DAX_logreturns, FTSE_logreturns)

# Use cor() with logreturns
cor(logreturns)

# Autocorrelation

# helps us study how each time series observation is related to its recent past
	# processes with greater autocorrelation are more predictable than those with lower autocorrelation

# lag 1 autocorrelation
	# correlation of 'today' with 'yesterday' within a series
	# e.g. if the price was high yesterday, the price is likely to be high today
# lag 2 autocorrelation
	# correlation of 'today' with 'yesterday' within a series
	# if the price was high two days ago, the price is likely to be high today

# the autocorrelation funciton
	# cor(stock_A[-100], stock_A[-1])
		# autocorrelation lag 1
	# cor(stock_A[-100], stock_A[-1])
		# autocorrelation lag 2
	# acf(stock_A, lag.max = 2, plot = FALSE)
		# autocorrelation by lag of several lags

DAX <- eu_stocks_df$DAX

# gives the autocorrelation for each lag under lag 2
acf(DAX, lag.max = 2, plot = FALSE)

# gives the autocorrelation for a series of lags 
acf(DAX, plot = FALSE) 

# gives an acf plot
acf(DAX, plot = TRUE) 


# Calculating Autocorrelations

# autocorrelations are lagged correlations are used to assess whether a time series is dependent on its past
	# for time series x of length n, we consider n-1 pairs of observations
	# the first pair is (x[2],x[1]), (x[3],x[2]), etc.
	# so such pair is (x[t], x[t-1])

# we could manually create these pairs of observations
	# first we create two vectors x_t0 and x_t1, each with length n-1
		# such that rows correspond to (x[t], x[t-1]) pairs
	# then we apply the cor() function to estimate the lag-1 autocorrelation

# acf() provides a shortcut for this
	# but will differ slightly from calculating autocorrelation manually through the cor() function
	# one is 1/(n-1) sample covariance vs. 1/n

# x is a premade series and was unavalable

# Define x_t0 as x[-1]
x_t0 <- x[-1]

# Define x_t1 as x[-n]
x_t1 <- x[-n]

# Confirm that x_t0 and x_t1 are (x[t], x[t-1]) pairs  
head(cbind(x_t0, x_t1))
  
# Plot x_t0 and x_t1
plot(x_t0, x_t1)

# View the correlation between x_t0 and x_t1
cor(x_t0, x_t1)

# Use acf with x
acf(x, lag.max = 1, plot = FALSE)

# Confirm that difference factor is (n-1)/n
cor(x_t1, x_t0) * (n-1)/n

