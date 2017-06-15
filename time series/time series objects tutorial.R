#Time Series Tutorial
  #http://a-little-book-of-r-for-time-series.readthedocs.io/en/latest/src/timeseries.html

#############################
# Time Series Data and ts() #
#############################

#Times-Series is a type of object in R, defined with the ts() funciton

#first lets analyze some historic data
#the following data is the age at time of death of Monarchs of England since William the Conquerer
kings <- scan("http://robjhyndman.com/tsdldata/misc/kings.dat",skip=3) #1st 3 lines of data are comments
kings

#now we can read the vector as a time series
kingstimeseries <- ts(kings) 
kingstimeseries

#monthly or seasonal data
births <- scan("http://robjhyndman.com/tsdldata/data/nybirths.dat") #vector of births per month in New York City
births
birthstimeseries <- ts(births, frequency=12, start=c(1946,1)) #read as a monthly time series
birthstimeseries

souvenir <- scan("http://robjhyndman.com/tsdldata/data/fancy.dat") #monthly sales at a souvenier shop
souvenir
souvenirtimeseries <- ts(souvenir, frequency=12, start=c(1987,1)) #as a time series
souvenirtimeseries

###############################
# Plotting Time Series Object #
###############################

#plotting the time series of English Monarchs
plot.ts(kingstimeseries) 

#plotting the time series of births in NYC
  #we can see the heavy seasonality of the data
  #could be described with an additive model
    #fluxuations are relatively constant over time
    #fluxuations do not depend on level of the series
plot.ts(birthstimeseries) 

#plot of souvenier shop sales
  #also heavily seasonal
    #fluxuations are predictable but not constant over time
    #fluxuations are dependant on level in the series
  #additive model not appropriate
plot.ts(souvenirtimeseries) 

#we do a natural log transformation of the souvenier shop series
  #now the seasonal fluxuations are relatively constant over time
  #fluxuations now not dependant on the level of the series
logsouvenirtimeseries <- log(souvenirtimeseries) #stays as time series object after transformation
plot.ts(logsouvenirtimeseries)

###########################
# Decomposing Time Series #
###########################

#a non-seasonal time series consists of a trend component and an irregular component
  #decomposing means
    #estimating the trend component
    #estimating the irregular component

#library("TTR") SMU() funciton
  #allows us to smooth a time series
library("TTR")
kingstimeseriesSMA3 <- SMA(kingstimeseries,n=3)
plot.ts(kingstimeseries) #original time series
plot.ts(kingstimeseriesSMA3) #3 monarch moving average

#now if we want to smooth it even more, to see longer trends
kingstimeseriesSMA8 <- SMA(kingstimeseries,n=8)
plot.ts(kingstimeseriesSMA8) #gives us a clearer picture of longer term trends in monarch age

#decompose()
  #return estimates the trend, seasonal, and irregular components of a time series 
  #return can be used in an additive model.
  #return is formatted as a list of objects

birthstimeseries #we return to the birth rate in NYC data

birthstimeseriescomponents <- decompose(birthstimeseries)
birthstimeseriescomponents #returns decomposed information on time series data
plot(birthstimeseriescomponents) #returns a plot of the list of components

########################
# Seasonally Adjusting #
########################

#with decompose() we can seasonally adjust our data by subtracting the seasonal variation
birthstimeseriescomponents <- decompose(birthstimeseries) #same operation we did before
birthstimeseriesseasonallyadjusted <- birthstimeseries - birthstimeseriescomponents$seasonal #subtract seasonal component

#we can now plot the result
plot(birthstimeseries) #original time series
plot(birthstimeseriesseasonallyadjusted) #seasonally adjusted time series

#########################################
# Forecasts using Exponential Smoothing #
#########################################

#can be used to make short term forecasts for time series data

#simple exponential smoothing
  #if your data follows an additive model, with constant level, and no seasonality:
    #you can use simple exponential smoothing to make short term forecasts
  #provides a way of estimating the level at the current time point
  #smoothing is controlled by parameter alpha:
    #alpha lies between 0 and 1
    #values of alpha that are close to 0 mean little weight is placed on recent observations

#annual rainfall data for London
rain <- scan("http://robjhyndman.com/tsdldata/hurst/precip1.dat", skip=1)
rain #constant level, random fluctuations, additive model appropriate
rainseries <- ts(rain,start=c(1813))
plot.ts(rainseries)

#HoltWinters() exponential forecasting
  #the function returns a list variable of several named elements

#we'll apply this to the London annual rainfall data
  #the output gives alpha parameter of 0.024
    #very close to 0
    #tells us the forecasts are based on both recent and less reent observations
    #more weight is being placed on the most recent observations
rainseriesforecasts <- HoltWinters(rainseries, beta=FALSE, gamma=FALSE)
rainseriesforecasts


#by default, HoltWinters() makes forecasts for the time period observed in the original series
  #HoltWinters() stored the forecast in our output list as rainseriesforeasts$fitted
rainseriesforecasts$fitted #gives us the forecasted values over our original time series observations
plot(rainseriesforecasts) #original data in black and fitted values in red
rainseriesforecasts$SSE #gives sum of squared errors of HoltWinters() forecast

#it is common in simple exponential smoothing to use the first value of the time series as the initial level
  #here the first observed value (the year 1813) in 23.56 inches
  #you can specify your own initial value for the level using the "l.start" parameter
    #for example, we can set the level to 23.56
HoltWinters(rainseries, beta=FALSE, gamma=FALSE, l.start=23.56)

#however, HoltWinters() can only make forecasts for the given observations
  #to make forecasts for further time points we need the "forecast" package

library("forecast")

#now we can make forecasts for further time points
  #we use the forecast.HoltWinters() function
  #you specify further time points by using the "h" parameter 
    #here we make a forecast for years 1814-1920
  #the forecast also gives a prediction window (80% and 95%)
rainseriesforecasts2 <- forecast.HoltWinters(rainseriesforecasts, h=8)
rainseriesforecasts2
plot.forecast(rainseriesforecasts2)

#forecast errors
  #calculated as observed values minus predicted values
    #we can only cover forecast errors for the time period covered by our original time series
  #one measure of accuracy of a model is sum-of-squared-errors, or SSE
    #for in sample forecast errors
  
#in-sample forecast errors
  #stored in the element "residuals" in the list returned by forecast.HoltWinters()
  #if the predictive model cannot be improved upon:
    #there sould be no correlations between forecast errors for successive predictions
  #if there are correlations between forecast errors for successive predictions
    #it is likely that the simple exponential smoothing forcasts could be improved upon 
      #by another forecasting technique

#to test this, we obtain a correlogram of the in sample forecast errors for lags 1-20
  #we calculate a correlogram of the forecast errors using the acf() function
    #specify the maximum lag you want to look at using the "lag.max" paramenter in acf()
  #we see that lag 3 is just touching the significance bounds
    #to test whether there is significant evidence for non-zero correlations at lags 1-20:
      #need to run a Ljung-Box test
      #can be performed using the "Box.test()" function
      #the max lag we want to look at is specified with the "lag" paramenter in Box.test()
  #below we find little evidence of non-zero autocorrelations with:
    #Ljung-Box statistic of 17.4
    #p-value of 0.6
    #tested for lags 1-20
acf(rainseriesforecasts2$residuals, lag.max=20, na.action = na.contiguous) #had to add parameter "na.action"
Box.test(rainseriesforecasts2$residuals, lag=20, type="Ljung-Box") #test if there are non-zero autocorrelations at lags 1-20
  
#we can also test whether forecast errors are normally distributed with mean zero and constant variance
  #we can make a time plot of the in-sample forecast errors:
    #the plot below shows that ther is roughtly constant variance over time
plot.ts(rainseriesforecasts2$residuals)

#we can also check wether the forecast errors are normally distributed with mean zero
  #this time we plot a histogram of forecast errors
    #this will be overlaid a normal curve with mean zero with the same standard deviation of distributed forecast errors
  #to do this wee need to create the function below:
plotForecastErrors <- function(forecasterrors) #function doesn't work
  {
     # make a histogram of the forecast errors:
     mybinsize <- IQR(forecasterrors)/4
     mysd   <- sd(forecasterrors)
     mymin  <- min(forecasterrors) - mysd*5
     mymax  <- max(forecasterrors) + mysd*3
     # generate normally distributed data with mean 0 and standard deviation mysd
     mynorm <- rnorm(10000, mean=0, sd=mysd)
     mymin2 <- min(mynorm)
     mymax2 <- max(mynorm)
     if (mymin2 < mymin) { mymin <- mymin2 }
     if (mymax2 > mymax) { mymax <- mymax2 }
     # make a red histogram of the forecast errors, with the normally distributed data overlaid:
     mybins <- seq(mymin, mymax, mybinsize)
     hist(forecasterrors, col="red", freq=FALSE, breaks=mybins)
     # freq=FALSE ensures the area under the histogram = 1
     # generate normally distributed data with mean 0 and standard deviation mysd
     myhist <- hist(mynorm, plot=FALSE, breaks=mybins)
     # plot the normal curve as a blue line on top of the histogram of forecast errors:
     points(myhist$mids, myhist$density, type="l", col="blue", lwd=2)
}

plotForecastErrors(rainseriesforecasts2$residuals) #now we plot the function we just built, broken

#Holt-Winters Exponential Smoothing - skirt diameter
  #this time series has increasing or decreasing trend and no seasonality
  #here we will have two parameters
    #alpha for estimates of the level
    #beta for slobe 'b' of the trend component
skirts <- scan("http://robjhyndman.com/tsdldata/roberts/skirts.dat",skip=5)
skirtsseries <- ts(skirts,start=c(1866))
plot.ts(skirtsseries)

skirtsseriesforecasts <- HoltWinters(skirtsseries, gamma=FALSE)
skirtsseriesforecasts
skirtsseriesforecasts$SSE

plot(skirtsseriesforecasts)
  #we can see that the in-sample forecasts agree pretty well with observed values
  #although they tend to lag behind observed values a little bit

#forecasting
skirtsseriesforecasts2 <- forecast.HoltWinters(skirtsseriesforecasts, h=19)
plot.forecast(skirtsseriesforecasts2)

#testing in-sample forecasting errors
  #here the correlogram shows that the sample autocorrelation for in-sample forecast errors:
    #exceeds significant bounds at lag 5 (on the correlogram)
  #Ljung-Box test p-value of 0.47
    #indicates that there is littlel evidence of non-zero autocorrelations 
      #at lags of 1-20
acf(skirtsseriesforecasts2$residuals, lag.max=20, na.action = na.contiguous)
Box.test(skirtsseriesforecasts2$residuals, lag=20, type="Ljung-Box")

#same as in previous data, still breaks!
plot.ts(skirtsseriesforecasts2$residuals)            # make a time plot
plotForecastErrors(skirtsseriesforecasts2$residuals) # make a histogram


#Holt-Winters Exponential Smoothing - Souvenir Shop
  #can estimate the level, slope, and seasonal component at the current time point
  #smoothing controlled by three parameters: 
    #alpha for estimates of the level
    #beta for slobe b of the trend component
    #gamma for the seasonal component
  #all parameters have values between 0 to 1
    #values close to '0' mean realitively little weight is placed on more recent obserations
  #we explore this using the souvenir time series from above
plot(souvenirtimeseries) 
logsouvenirtimeseries <- log(souvenirtimeseries) #logrithem transformation
souvenirtimeseriesforecasts <- HoltWinters(logsouvenirtimeseries)
souvenirtimeseriesforecasts
souvenirtimeseriesforecasts$SSE

#above we see that
  #the value of alpha (0.41) is relatively low
    #indicating the level of the current point is based on more recent observations
      #and some observations in the more distant past
  #the value of beta (0.00) indicates the slope of the trend line was not updated
    #this makes sense, as that's why we applied the logrithmic transformation 
  #the value of gamma (0.96) is high, indicating a strong seasonal component
plot(souvenirtimeseriesforecasts) #we plot the forecast of observations
  #we see that the Holt-Winters exponential method is successful in predicting seasonal peaks

#now we forecast future time periods
souvenirtimeseriesforecasts2 <- forecast.HoltWinters(souvenirtimeseriesforecasts, h=48)
plot.forecast(souvenirtimeseriesforecasts2)

#now we investigate whether the predictive model can be improved
  #checking in-sample forecast errors
  #we see that in sample forecasting errors do not succeed significant bounds for lags 1-20
  #p-value for Ljung-Box test is 0.6, indicating little evidence of non-zero autocorrelations
acf(souvenirtimeseriesforecasts2$residuals, lag.max=20, na.action = na.contiguous) #added the na.action parameter
Box.test(souvenirtimeseriesforecasts2$residuals, lag=20, type="Ljung-Box")
  
#same as earlier, also doesn't work...
plot.ts(souvenirtimeseriesforecasts2$residuals)            # make a time plot
plotForecastErrors(souvenirtimeseriesforecasts2$residuals) # make a histogram


################
# ARIMA Models #
################

#expinential smoothing methods are useful for making forecasts
  #also make no assumptions about the correlations between successive values of the time series
  #if you wan tto make prediction intervals for forecasts using expenential smoothing:
    #the prediction intervals require that the forecast errors are:
      #uncorrelated
      #with mean zero
      #with constant varience
  #they make any assumptions about correlations between successive values of a time series
    #however, you may get better predictive modeling by taking correlations in the data into account
      #this is the ARIMA family of models
      #ARIMA allows for explicit statistical model for irregular component of a time series
      #allows for non-zero autocorrelations in the irregular movement

#Autoregressive Integrated Moving Average (ARIMA) models
  #are defined for stationary series
  #if you start with a non-stationary series:
    #you will need to 'difference' the time series until you obtain a stationary series
  #if you have to difference the time series 'd' times:
    #you have an ARIMA(p,d,q) model, where 'd' is the differencing used

#differencing a time series
  #you can difference a time series using the diff() function in R
  #the following time series does not have a stationary mean
plot.ts(skirtsseries) #original
skirtsseriesdiff1 <- diff(skirtsseries, differences=1)
plot.ts(skirtsseriesdiff1) #differenced time series

#the time series is still does not have a stationary mean after the first differencing
  #we can difference the series again
  #now we see the series is stationary in mean and varience
    #the level of the series seems conistent over time
skirtsseriesdiff2 <- diff(skirtsseries, differences=2)
plot.ts(skirtsseriesdiff2) #plot of the twice differenced series

#if you need to difference your time series you can use an ARIMA(p,d,q) model
  #if you are differencing twice it would mean you have an ARIMA(p,2,q) model 
    #the 'd' stands for difference[d]
  #now we have to figure out 'p' and 'q' in the ARIMA(p,d,q) model

#another example can be found in our Monarchs of England series
plot.ts(kingstimeseries)
kingtimeseriesdiff1 <- diff(kingstimeseries, differences=1)
plot.ts(kingtimeseriesdiff1) #the series is stationary after the transformation
                             #so an ARIMA(p,1,q) model is probably appropriate

#by taking a series' differences, we can eliminate the trend component from the data.
  #now left with an irregular componentTo plot a correlogram and partial correlogram, we can use the “acf()” and “pacf()” functions in R, respectively. To get the actual values of the autocorrelations and partial autocorrelations, we set “plot=FALSE” in the “acf()” and “pacf()” functions.

#Selecting a candidate ARIMA model
  #if your dataset is stationary, or you have transformed your dataset into stationarity
    #then the next step is to select an appropriate ARIMA model
  #to do this you usually have to examine the correlogram or partial correlogram of a series

#To plot a correlogram and partial correlogram, we can use the “acf()” and “pacf()” functions
  #To get the actual values of the autocorrelations and partial autocorrelations:
    #we set “plot=FALSE” in the “acf()” and “pacf()” functions.

acf(kingtimeseriesdiff1, lag.max=20)             # plot a correlogram
acf(kingtimeseriesdiff1, lag.max=20, plot=FALSE) # get the autocorrelation values

#we can see from above that lag 1 of -0.360 exceeds the significant bounds
  #we now examine the partical correlogram for lags 1-20 of the same series

pacf(kingtimeseriesdiff1, lag.max=20)             # plot a partial correlogram
pacf(kingtimeseriesdiff1, lag.max=20, plot=FALSE) # get the partial autocorrelation values

#the partial correlogram shows that partial autocorrelations of 1,2, and 3 exceed significance bounds
  #are negative
  #and are slowly decreasing in magnitude with increasing lag
  #the autocorrelations are 0 after lag 3

#the correlogram is zero after lag 1
  #and the partial correlogram tails off to zero after lag 3
  #this means that the following ARMA (Autoregressive Moving Average) models are possible for the time series of first differences
    #ARMA(3,0)
      #autoregressive model of order p=3 
      #since the partial autocorrelogram is zero after lag 3
    #ARMA(0,1) 
      #moving average model of order q=1
      #since the autocorrelogram is zero after lag 1 
      #and the partial autocorrelogram tails off to zero
    #ARMA(p,q) model that is, a mixed model with p and q greater than 0
     #since the auto correlogram and partial tail off to zero
        #although with the correlogram probably tails off to zero too abruptly for this model to be appropriate

#we use the principle of parcimony to deide which model is best:
  #we assume that the model with the fewest parameters is best
    #the ARMA(3,0) model has 3 parameters
    #the ARMA(0,1) model has 1 parameter
    #and ARMA(p,q) has at least 2 parameters
    #therefore, ARMA(0,1) is taken to be the best

#ARMA(0,1) is a moving average model of order 1 or MA(1) model
  #this model can be written as
    # X_t - mu = Z_t - (theta * Z_t-1) 
      #where X_t is the stationary time series we are studying
        #in this case, the first difference of the English Monarchs
      #mu is the mean of the time series X_t
      #Z_t is white noise with mean zero and constant variance
      #theta is the parameter to be estimated

#A MA (Moving Average) model is usually used to model a time series that shows:
  #short-term dependencies between successive observations
  #intutively it makes sense to use an MA model on the English Monarchs time series
  
#since ARMA(0,1) model with p=0, q=1 is taken
  #the original time series of the English Monarch's age of death series can be modeled:
    #ARIMA(0,1,1) model

#Example of the Volcanic Dust Veil in the Northern Hemisphere
volcanodust <- scan("http://robjhyndman.com/tsdldata/annual/dvi.dat", skip=1)
volcanodustseries <- ts(volcanodust,start=c(1500))
plot.ts(volcanodustseries)

#from the above plot, it appears the model has stationarity, so an additive model might be appropriate
  #time series appears consistent in mean and variance
  #level also appears roughly stable over time
  #therefore we don't need to apply transformations to the model to fit an ARIMA model
    #we can apply it to the original series

acf(volcanodustseries, lag.max=20)             # plot a correlogram, to lag = 20
acf(volcanodustseries, lag.max=20, plot=FALSE) # get the values of the autocorrelations

#We see from the correlogram that the autocorrelations for lags 1, 2 and 3 exceed the significance bounds
  #autocorrelations tail off to zero after lag 3
  #The autocorrelations for lags 1, 2, 3 are positive
    #and decrease in magnitude with increasing lag (lag 1: 0.666, lag 2: 0.374, lag 3: 0.162).

#The autocorrelation for lags 19 and 20 exceed the significance bounds too
  #however, it is likely that this is due to chance
    #since they just exceed the significance bounds (especially for lag 19)
    #the autocorrelations for lags 4-18 do not exceed the signifiance bounds
      #we would expect 1 in 20 lags to exceed the 95% significance bounds by chance alone.

pacf(volcanodustseries, lag.max=20)
pacf(volcanodustseries, lag.max=20, plot=FALSE)

#we see that the partial autocorrelation at lag 1 is positive and exceeds the significance bounds (0.666)
  #while the partial autocorrelation at lag 2 is negative and also exceeds the significance bounds (-0.126)

#Given the correlograms, the following models seem appropriate:
  #an ARMA(2,0) model
    #since the partial autocorrelogram is zero after lag 2
    #the correlogram tails off to zero after lag 3
    #the partial correlogram is zero after lag 2
  #an ARMA(0,3) model
    #since the autocorrelogram is zero after lag 3
    #the partial correlogram tails off to zero (although perhaps too abruptly for this model to be appropriate)
  #an ARMA(p,q) mixed model
    #since the correlogram and partial correlogram tail off to zero 
      #(although the partial correlogram perhaps tails off too abruptly for this model to be appropriate)

#The ARMA(2,0) is an autoregressive model of order 2, or AR(2) model
  #can be written as: X_t - mu = (Beta1* (X_t - mu)) + (Beta2 * (Xt-2 - mu)) + Z_t
    #where X_t is the stationary time series we are studying
    #mu is the mean of time series X_t
    #Beta1 and Beta2 are parameters to be estimated
    #Z_t is white noise with mean zero and constant variance

#an AR (autoregressive) model
  #usually shows longer term dependencies between successive observations
  #we expec tthe volcanic dust veil index to be an AR model
    #we expect volcanic dust and aerosol levels to affect those in much later years
      #as they are unlikely to disappear quickly

#if ARMA(2,0) model (with p=2, q=0) is used 
  #then it would mean that ARIMA(2,0,0) model can be used (with p=2, d=0, q=0)

####################################
# Forecasting USing an ARIMA Model #
####################################

#the English Monarch series with ARIMA(0,1,1)
  #you can specify the (p,d,q) balues with the "order" argument in the arima() function
kingstimeseriesarima <- arima(kingstimeseries, order=c(0,1,1)) # fit an ARIMA(0,1,1) model
kingstimeseriesarima

#we can use the "forecast" package to forecast future data points for our data
  #here we estimate the values of the ages of the next 5 English Monarchs
  #also given are the 80% and 90% confidence intervals for the projected data
library("forecast") # load the "forecast" R library
kingstimeseriesforecasts <- forecast.Arima(kingstimeseriesarima, h=5)
kingstimeseriesforecasts
plot.forecast(kingstimeseriesforecasts)

#just like in exponential functions, it is useful to check our standard errors in ARIMA funcitons
  #we want to see forecast errors that are normally distributed of mean zero with constant variance
  #the correlogram (below) shows no lags lying outside significance bounds
  #d the p-value for the Ljung-Box test is 0.9
  #we can conclude that there is very little evidence for non-zero autocorrelations

plot.ts(kingstimeseriesforecasts$residuals)            # make time plot of forecast errors
plotForecastErrors(kingstimeseriesforecasts$residuals) # make a histogram
 
#the time plot of in sample forecast errors seems to be consistent over time
  #though perhaps slightly higher varience towards the end of the series
  #The histogram of the time series shows
    #that the forecast errors are roughly normally distributed 
    #the mean seems to be close to zero.

#Since successive forecast errors do not seem to be correlated
  #and the forecast errors seem to be normally distributed with mean zero and constant variance
  #the ARIMA(0,1,1) does seem to provide an adequate predictive model 

