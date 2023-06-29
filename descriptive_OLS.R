library(tidyverse)
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

df <- read.csv("C:/Users/nicho/Documents/GitHub/MacroExperimentGhana/data.csv")
df <- rename(df,
             Monetary_Policy_Rate = 'Monetary.Policy.Rate....', 
             GDP_Growth = 'Bank.of.Ghana.Composite.Index.of.Economic.Activity..Real.Growth......',
             Headline_Inflation ='Headline.Inflation.....Year.on.Year' )
df <- na.omit(subset(df, select=-Core.Inflation..Adjusted.for.Energy...Utility......Year.on.Year))
df$Date <- as.Date(df$Date, format="%m/%d/%Y")

# group by series
df <- melt(df, id.vars = 'Date', variable.name = 'series')

ggplot(data = df, aes(x = Date, y = value, group = series),) +
  geom_line(aes(colour=series))

df <- na.omit(read.csv("C:/Users/nicho/Documents/GitHub/MacroExperimentGhana/regression_data.csv"))
df <- rename(df,
             GDP_Growth = 'GDP.growth..annual...', 
             GDP_per_Worker = 'GDP.per.person.employed..constant.2017.PPP...',
             M3_Supply_of_GDP ='Broad.money....of.GDP.',
             Labor_Force = 'Labor.force..total',
             CPI = "Consumer.price.index..2010...100.")
df <- df %>%
  mutate(log_GDP_Growth = log(GDP_Growth),
         log_GDP_per_Worker = log(GDP_per_Worker),
         log_Labor_Force = log(Labor_Force),
         log_CPI = log(CPI))

plot_data <- melt(df, id.vars = 'Year', variable.name = 'series')
ggplot(data = plot_data, aes(x = Year, y = value, group = series),) +
  geom_line(aes(colour=series)) +
  facet_wrap(~ series, scales = "free")

