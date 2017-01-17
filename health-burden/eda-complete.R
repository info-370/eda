# Exploratory data analysis 

# Set up (install packages if you don't have them)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(vioplot)
setwd('~/Documents/info-370/eda/health-burden/')
risk.data <- read.csv('./data/prepped/risk-data.csv', stringsAsFactors = FALSE) 

######################
### Data Structure ###
######################

## Using a variety of functions, investigate the structure of your data

# Dimensions of the data
dim(risk.data)

# Column names
colnames(risk.data)

# Structure of the data
str(risk.data)

# Summary of each column
summary(risk.data)

# See data (in RStudio)
View(risk.data)

# Test if first 6 columns uniquely identify each row
which(duplicated(risk.data[1:6],)) 

# See which ages are present
unique(risk.data$age)

# Replace NAs as 0s
risk.data[is.na(risk.data)] <- 0

###########################
### Univariate Analysis ###
###########################

## Using a variety of approaches, investigate the structure each (risk column) individually

# Summarize
summary(risk.data[,8:ncol(risk.data)])
hist(risk.data$deaths.rate)
 
# Histograms
hist(risk.data$drug.use) 
hist(risk.data$high.meat)
hist(risk.data$low.exercise)
hist(risk.data$smoking)
hist(risk.data$alcohol.use) # wait, what...?

# Violin plot for each variable
vioplot(
        risk.data$smoking, 
        risk.data$alcohol.use, 
        risk.data$drug.use,
        risk.data$high.meat,
        risk.data$low.exercise, 
        names=c('Smoking', 'Alcohol', 'Drugs', 'Meat', 'Low Exercise')
        )

# Boxplots for each variable (need to reshape first)
long.data <- gather(risk.data, risk, value, smoking, alcohol.use, drug.use, high.meat, low.exercise)
boxplot(value ~ risk, data = long.data, las=2)


####################################
### Univariate Analysis (by age) ###
####################################

# Investiage how each risk-variable varies by **age group**

# Boxplot by age
boxplot(smoking ~ age, data = risk.data, las=2)

# Violin plot by age
low.age <- risk.data %>% filter(age == "15-49 years")
mid.age <- risk.data %>% filter(age == "50-69 years")
old.age <- risk.data %>% filter(age == "70+ years")
vioplot(
  low.age$smoking, 
  mid.age$smoking, 
  old.age$smoking, 
  names=c('15-49','50-69', '70+'))

# Histograms by age
p <- qplot(smoking, data = risk.data, geom = "histogram")
p + facet_wrap(~ age)

p <- qplot(alcohol.use, data = risk.data, geom = "histogram")
p + facet_wrap(~ age)

p <- qplot(high.meat, data = risk.data, geom = "histogram")
p + facet_wrap(~ age)

p <- qplot(low.exercise, data = risk.data, geom = "histogram")
p + facet_wrap(~ age)

p <- qplot(drug.use, data = risk.data, geom = "histogram")
p + facet_wrap(~ age)

####################################
### Univariate Analysis (by sex) ###
####################################

# Investiage how each risk-variable varies by **sex**

# Histograms by sex
p <- qplot(smoking, data = risk.data, geom = "histogram")
p + facet_wrap(~ sex)

p <- qplot(alcohol.use, data = risk.data, geom = "histogram")
p + facet_wrap(~ sex)

p <- qplot(high.meat, data = risk.data, geom = "histogram")
p + facet_wrap(~ sex)

p <- qplot(low.exercise, data = risk.data, geom = "histogram")
p + facet_wrap(~ sex)

p <- qplot(drug.use, data = risk.data, geom = "histogram")
p + facet_wrap(~ sex)

# Compare male to female values -- requires reshaping (and dropping population)!
wide.by.sex <- long.data %>% 
                select(-pop) %>% 
                spread(sex, value)

plot(wide.by.sex$male, wide.by.sex$female)

# Get hovers via plotly
p <- plot_ly(data = wide.by.sex, x = ~male, y = ~female, 
             text = ~paste("Risk: ", risk,
                           '<br>Country:', country,
                           '<br>Age:', age
                           ))
p

########################################
### Univariate Analysis (by country) ###
########################################

## Investiage how each risk-variable varies by **country**

# Aggregate by country
by.country <- risk.data %>% 
              group_by(country, country.code) %>% 
              summarize(smoking = sum(smoking * pop), pop=sum(pop)) %>% 
              ungroup() %>% 
              mutate(smoking.rate = smoking / pop)
              
# Choropleth map (see https://plot.ly/r/choropleth-maps/)

l <- list(color = toRGB("grey"), width = 0.5)
    
# specify map projection/options
g <- list(
  showframe = FALSE,
  showcoastlines = FALSE,
  projection = list(type = 'Mercator')
)

p <- plot_geo(by.country) %>%
  add_trace(
    z = ~smoking.rate, color = ~smoking.rate, colors = 'Blues',
    text = ~country, locations = ~country.code, marker = list(line = l)
  ) %>%
  colorbar(title = 'Smoking Death Rate') %>%
  layout(
    title = 'Smoking Death Rates',
    geo = g
  )

p

###########################
### Bivariate Analysis ####
###########################

# Compare risks-variables to one another
pairs(risk.data[,8:ncol(risk.data)])