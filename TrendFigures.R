library(tidyverse)
data <- read.csv("regression_data.csv")
library(ggplot2)
library(readr)
data <- read_csv("regression_data.csv")
## Trend graphs for Ghana
# Plot for GDP growth
p1 <- ggplot(data, aes(x = Year, y = `GDP growth (annual %)`)) +
  geom_line(color = "darkred", size = 1.5) +  # Change the appearance of the line
  labs(
    x = "Year", 
    y = "GDP Growth (annual %)", 
    title = "Trend of GDP Growth",
    caption = "Data source: World Development Indicators"
  ) +
  theme_bw() +  # Use a white background theme
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 20),  # Change the appearance of the title
    axis.title = element_text(face = "bold", size = 14),  # Change the appearance of axis labels
    axis.text = element_text(size = 12),  # Change the appearance of axis tick labels
    panel.grid.major = element_line(color = "grey60", linetype = "dashed"),  # Change the appearance of major grid lines
    panel.grid.minor = element_blank()  # Remove minor grid lines
  )
print(p1)

## Plot for Broad Money
p2 <- ggplot(data, aes(x = Year, y = `Broad money (% of GDP)`)) +
  geom_line(color = "darkred", size = 1.5) +  # Change the appearance of the line
  labs(
    x = "Year", 
    y = "Broad Money (% of GDP)", 
    title = "Trend of Broad Money",
    caption = "Data source: World Development Indicators"
  ) +
  theme_bw() +  # Use a white background theme
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 20),  # Change the appearance of the title
    axis.title = element_text(face = "bold", size = 14),  # Change the appearance of axis labels
    axis.text = element_text(size = 12),  # Change the appearance of axis tick labels
    panel.grid.major = element_line(color = "grey60", linetype = "dashed"),  # Change the appearance of major grid lines
    panel.grid.minor = element_blank()  # Remove minor grid lines
  )

print(p2)

## Plot for GDP per person employed (constant 2017 PPP $)
p3 <- ggplot(data, aes(x = Year, y = `GDP per person employed (constant 2017 PPP $)`)) +
  geom_line(color = "darkred", size = 1.5) +  # Change the appearance of the line
  labs(
    x = "Year", 
    y = "GDP Per Capita", 
    title = "Trend of GDP/Capita",
    caption = "Data source: World Development Indicators"
  ) +
  theme_bw() +  # Use a white background theme
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 20),  # Change the appearance of the title
    axis.title = element_text(face = "bold", size = 14),  # Change the appearance of axis labels
    axis.text = element_text(size = 12),  # Change the appearance of axis tick labels
    panel.grid.major = element_line(color = "grey60", linetype = "dashed"),  # Change the appearance of major grid lines
    panel.grid.minor = element_blank()  # Remove minor grid lines
  )
print(p3)

## Plot for "Labor force, total"
p4 <- ggplot(data, aes(x = Year, y = `Labor force, total`)) +
  geom_line(color = "darkred", size = 1.5) +  # Change the appearance of the line
  labs(
    x = "Year", 
    y = "Labor Force", 
    title = "Trend of Labor Force",
    caption = "Data source: World Development Indicators"
  ) +
  theme_bw() +  # Use a white background theme
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 20),  # Change the appearance of the title
    axis.title = element_text(face = "bold", size = 14),  # Change the appearance of axis labels
    axis.text = element_text(size = 12),  # Change the appearance of axis tick labels
    panel.grid.major = element_line(color = "grey60", linetype = "dashed"),  # Change the appearance of major grid lines
    panel.grid.minor = element_blank()  # Remove minor grid lines
  )
print(p4)

## Grid layout for export
install.packages("gridExtra")
library(gridExtra)
grid.arrange(p1, p3, p4, p2, ncol = 2)
g <- arrangeGrob(p1, p3, p4, p2, ncol = 2)
ggsave("plots.png", g, width = 15, height = 15, dpi = 300)


