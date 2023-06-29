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
library(gridExtra)

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

# M3/GDP vs log GDP Growth
reg1 = lm(df$M3_Supply_of_GDP ~ df$log_GDP_Growth)
summary(reg1)
beta1 = reg1$coefficients['df$log_GDP_Growth']
plot1 <- ggplot(select(df, M3_Supply_of_GDP, log_GDP_Growth), 
               aes(x = log_GDP_Growth, y = M3_Supply_of_GDP)) +
  geom_line(colour='red') +
  geom_smooth(method = "lm",
              level = 0.99)


# M3/GDP vs log GDP/Worker
reg2 = lm(df$M3_Supply_of_GDP ~ df$log_GDP_per_Worker)
summary(reg2)
beta2 = reg2$coefficients['df$log_GDP_per_Worker']
plot2 <- ggplot(select(df, M3_Supply_of_GDP, log_GDP_per_Worker), 
               aes(x = log_GDP_per_Worker, y = M3_Supply_of_GDP)) +
  geom_line(colour='green') +
  geom_smooth(method = "lm",
              level = 0.99)

# M3/GDP vs log Labor Force
reg3 = lm(df$M3_Supply_of_GDP ~ df$log_Labor_Force)
summary(reg3)
beta3 = reg3$coefficients['df$log_Labor_Force']
plot3 <- ggplot(select(df, M3_Supply_of_GDP, log_Labor_Force), 
               aes(x = log_Labor_Force, y = M3_Supply_of_GDP)) +
  geom_line(colour='purple') +
  geom_smooth(method = "lm",
              level = 0.99)

# M3/GDP vs log CPI
reg4 = lm(df$M3_Supply_of_GDP ~ df$log_CPI)
summary(reg4)
beta4 = reg4$coefficients['df$log_CPI']
plot4 <- ggplot(select(df, M3_Supply_of_GDP, log_CPI), 
               aes(x = log_CPI, y = M3_Supply_of_GDP)) +
  geom_line(colour='orange') +
  geom_smooth(method = "lm",
              level = 0.99)

grid.arrange(`plot1`, `plot2`, `plot3`, `plot4`, nrow=2)
message(paste(c("coefficients:", 
                "\nGDP Growth: ", beta1, 
                ", GDP per Worker: ", beta2,
                ", Labor Force: ", beta3, 
                ", CPI: ", beta4), collapse=""))
