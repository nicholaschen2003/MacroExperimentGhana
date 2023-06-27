# Vector Autoregression Model for Monetary Policy in Ghana
install.packages("vars")
install.packages("tseries")
install.packages("urca")

# Libraries
library(tidyverse)
library(readr)
library(lubridate)
library(zoo)
library(vars)
library(tseries)
library(urca)
library(MASS)

# Install and load necessary packages
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("vars")) install.packages("vars")
if (!require("tseries")) install.packages("tseries")

# Read data from CSV file
df <- read.csv("data.csv")
print(df)

# Update date column to Date type
df$Date <- as.Date(df$Date, format="%m/%d/%Y")

# Order data by date
df <- df %>%
  arrange(Date)

# Select only the columns of interest
df <- df %>% 
  dplyr::select("Date", 'Monetary Policy Rate (%)', 'Bank of Ghana Composite Index of Economic Activity (Real Growth) (%)', 'Core Inflation (Adjusted for Energy & Utility) (%) Year-on-Year', 'Headline Inflation (%) Year-on-Year') %>%
  rename(
    Monetary_Policy_Rate = 'Monetary Policy Rate (%)', 
    GDP_Growth = 'Bank of Ghana Composite Index of Economic Activity (Real Growth) (%)',
    Core_Inflation = 'Core Inflation (Adjusted for Energy & Utility) (%) Year-on-Year',
    Headline_Inflation = 'Headline Inflation (%) Year-on-Year' 
  )

# Convert the dataframe to a time-series object
#ts_data <- ts(df[,-1], start=c(year(min(df$Date)), month(min(df$Date))), frequency=12)

# Check the structure of the dataframe
print(str(df))

# Convert the dataframe to a time-series object
ts_data <- ts(df[,-1], start=c(year(min(df$Date)), month(min(df$Date))), frequency=12)
print(dim(ts_data))
ts_data_diff <- diff(ts_data)
print(dim(ts_data_diff))

# Check the structure of the time-series object
print(str(ts_data))

# Remove NA values and conduct initial stationary test
df <- df %>% 
  drop_na()

for (col in colnames(df[-1])){
  ts_data <- ts(df[, col])
  print(col)
  print(adf.test(ts_data, alternative = "stationary"))
}

# If data is non-stationary, difference it
ts_data <- diff(ts_data)

# print length and head of ts_data before differencing
print(length(ts_data))
print(head(ts_data))

# If data is non-stationary, difference it
ts_data_diff <- diff(ts_data)

# print length and head of ts_data after differencing
print(length(ts_data_diff))
print(head(ts_data_diff))

#Convert ts_data (time series object) back to a data frame
ts_data <- as.data.frame(diff(ts_data))

# Stationarity tests after differencing
for(col in colnames(ts_data)){
  print(col)
  print(adf.test(ts_data[,col], alternative = "stationary"))
}
var_model <- VAR(ts_data, lag.max = 2, type = "const")

# Print results
print(summary(var_model))
