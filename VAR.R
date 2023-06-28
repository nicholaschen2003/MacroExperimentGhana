# Vector Autoregression Model for Monetary Policy in Ghana
install.packages("vars")
install.packages("tseries")
install.packages("urca")

# Install and load necessary packages
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("vars")) install.packages("vars")
if (!require("tseries")) install.packages("tseries")

# Libraries
library(tidyverse)
library(readr)
library(lubridate)
library(zoo)
library(vars)
library(tseries)
library(urca)
library(MASS)


setwd("/Users/shivantkrishnan/MacroExperimentGhana")
# Read data from CSV file
df <- read.csv("data.csv")
print(df)

# Update date column to Date type
df$Date <- as.Date(df$Date, format="%m/%d/%Y")
names(df)

# Select only the columns of interest
df <- df %>%
  dplyr::select('Date', 'Monetary.Policy.Rate....', 
                'Bank.of.Ghana.Composite.Index.of.Economic.Activity..Real.Growth......', 
                'Headline.Inflation.....Year.on.Year',
                ) %>%
  rename(
    Monetary_Policy_Rate = 'Monetary.Policy.Rate....', 
    GDP_Growth = 'Bank.of.Ghana.Composite.Index.of.Economic.Activity..Real.Growth......',
    Headline_Inflation ='Headline.Inflation.....Year.on.Year' )

# Convert the dataframe to a time-series object
#ts_data <- ts(df[,-1], start=c(year(min(df$Date)), month(min(df$Date))), frequency=12)

# Check the structure of the dataframe
print(str(df))
# first, install and load the mFilter package if you haven't already done so
install.packages("mFilter")
library(mFilter)


## Handling missing values for each column, if any
## df$gdp_growth <- na.omit(df$gdp_growth)
## df$core_inflation <- na.omit(df$core_inflation)
## df$Monetary_Policy_Rate <- na.omit(df$Monetary_Policy_Rate)
## df$Headline_Inflation <- na.omit(df$Headline_Inflation)
## df <- na.omit(df)


if(is.null(df$gdp_growth)) print("gdp_growth is NULL")
if(is.null(df$Monetary_Policy_Rate)) print("Monetary_Policy_Rate is NULL")
if(is.null(df$Headline_Inflation)) print("Headline_Inflation is NULL")

df <- df[complete.cases(df[,-1]),]
print(df)

if(any(is.na(df))){
  print("There are still NA values in the dataframe")
} else {
  print("There are no more NA values in the dataframe")
}

## Check numeric
numeric_check <- sapply(df[,c("GDP_Growth", "Monetary_Policy_Rate", "Headline_Inflation")], is.numeric)


## Applying the HP filter to all series except "Date" and creating a new dataframe
df_hp <- df
df_hp$GDP_Growth_hp <- hpfilter(df$GDP_Growth, freq = 129600)$cycle
df_hp$Monetary_Policy_Rate_hp <- hpfilter(df$Monetary_Policy_Rate, freq = 129600)$cycle
df_hp$Headline_Inflation_hp <- hpfilter(df$Headline_Inflation, freq = 129600)$cycle

show(df_hp)
# convert your dataframe to a time series object
start_year <- year(min(df$Date))
start_month <- month(min(df$Date))

# Creating a copy of df_hp and removing Date column
df_hp_no_date <- df_hp[,-1]

# Removing NA values
df_hp_no_date <- na.omit(df_hp_no_date)

# Convert to time series
ts_data <- ts(df_hp_no_date, start=c(start_year, start_month), frequency=12)

# Initial ADF test
for (col in colnames(ts_data)){
  print(col)
  print(adf.test(ts_data[, col], alternative = "stationary"))
}

# Differencing the data
ts_data_diff <- diff(ts_data)

# ADF tests after differencing
for(col in colnames(ts_data_diff)){
  print(col)
  print(adf.test(ts_data_diff[,col], alternative = "stationary"))
}
# install and load the caret package
if (!require(caret)) install.packages('caret')
library(caret)

# Compute the near zero variance predictors
nzv <- nearZeroVar(df_hp_no_date, saveMetrics= TRUE)

# Print the predictors
print(nzv)
df_hp_no_date <- df_hp_no_date[, !nzv$nzv]
# install and load the car package
if (!require(car)) install.packages('car')
library(car)

# compute the VIF
vif_values <- vif(lm(GDP_Growth ~., data = df_hp_no_date))

# print the VIF values
print(vif_values)

# Building the VAR model
var_model <- VAR(ts_data_diff, lag.max = 2, type = "const")

# Print results
print(summary(var_model))

# Assuming var_model is the estimated VAR model
irf_result <- irf(var_model, impulse = "Monetary_Policy_Rate", response = c("GDP_Growth", "Headline_Inflation"), n.ahead = 10)

# Print the impulse response functions
print(irf_result)
plot(irf_result)





































































## ------------------------------------------------------------------
# convert your dataframe to a time series object
# ts_data <- ts(df_hp)
#start_year <- year(min(df$Date))
#start_month <- month(min(df$Date))

#ts_data <- ts(df_hp[,-1], start=c(start_year, start_month), frequency=12)
#print(ts_data)
#ts_data_diff <- diff(ts_data)

# Check the structure of the time-series object
#print(str(ts_data))

# Remove NA values and conduct initial stationary test
#df <- df %>% 
#drop_na()

#for (col in colnames(df[-1])){
 # ts_data <- ts(df[, col])
 # print(col)
 # print(adf.test(ts_data, alternative = "stationary"))
#}

# If data is non-stationary, difference it
#ts_data <- diff(ts_data)

# print length and head of ts_data before differencing
#print(length(ts_data)
#print(head(ts_data))

#Convert ts_data (time series object) back to a data frame
#ts_data <- as.data.frame(diff(ts_data))
#print(ts_data)
# Stationarity tests after differencing
#for(col in colnames(ts_data_diff)){
#  print(col)
#  print(adf.test(ts_dataP_diff[,col], alternative = "stationary"))
#}
#var_model <- VAR(ts_data_diff, lag.max = 4, type = "const")

# Print results
#print(summary(var_model))
