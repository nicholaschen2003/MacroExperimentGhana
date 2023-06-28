library(ggplot2)
library(reshape2)
library(tseries)
library(AER)
library(dynlm)
library(forecast)
library(stargazer)
library(scales)
library(quantmod)
library(urca)

df <- na.omit(read.csv("C:/Users/nicho/Documents/GitHub/MacroExperimentGhana/data.csv"))
df <- rename(df,
             Monetary_Policy_Rate = 'Monetary.Policy.Rate....', 
             GDP_Growth = 'Bank.of.Ghana.Composite.Index.of.Economic.Activity..Real.Growth......',
             Headline_Inflation ='Headline.Inflation.....Year.on.Year' )
df <- subset(df, select=-Core.Inflation..Adjusted.for.Energy...Utility......Year.on.Year)
df$Date <- as.Date(df$Date, format="%m/%d/%Y")

# group by series
df <- melt(df, id.vars = 'Date', variable.name = 'series')

ggplot(data = df, aes(x = Date, y = value, group = series),) +
  geom_line(aes(colour=series))

