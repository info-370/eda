# Exploratory data analysis 

# Set up
library(dplyr)
library(ggplot2)
library(plotly)
library(vioplot)
setwd('~/Documents/info-370/eda/health-burden/')
health.data <- read.csv('./data/prepped/burden-data.csv', stringsAsFactors = FALSE)

######################
### Data Structure ###
######################

# Dimensions of the data
dim(health.data)

# Column names
colnames(health.data)

# Structure of the data
str(health.data)

# Summary of each column
summary(health.data)

# Check that percents are in the proper range
health.data %>% select(contains('percent')) %>% summary()

# See data (in RStudio)
View(health.data)

# Test if first 6 columns uniquely identify each row
which(duplicated(health.data[1:6],)) 

# See which causes are present
unique(health.data$cause)

# Which columns take on an NA value?
health.data %>% filter()

# Replace NAs as 0s
health.data[is.na(health.data)] <- 0

###########################
### Univariate Analysis ###
###########################

# Summarize
summary(health.data[,8:ncol(health.data)])
hist(health.data$deaths.rate)
 
# Histograms
hist(health.data$dalys.number) # Not super helpful
hist(health.data$dalys.percent) # Still not super helpful
hist(health.data$dalys.rate) # Still not super helpful

# Boxplots by age
boxplot(deaths.rate ~ age, data = health.data, las=2)

# Violin plot by age
under.5 <- health.data %>% filter(age == "Under 5", !is.na(deaths.rate))
young.age <- health.data %>% filter(age == "5-14 years", !is.na(deaths.rate))
low.age <- health.data %>% filter(age == "15-49 years", !is.na(deaths.rate))
mid.age <- health.data %>% filter(age == "50-69 years", !is.na(deaths.rate))
old.age <- health.data %>% filter(age == "70+ years", !is.na(deaths.rate))
vioplot(under.5$deaths.rate, 
        young.age$deaths.rate, 
        low.age$deaths.rate, 
        mid.age$deaths.rate, 
        old.age$deaths.rate, 
        names=c('Under 5', '5-14', '15-49','50-69', '70+'))

# Check histograms for only one cause/age combination
stomach <- health.data %>% 
    filter(cause == "Stomach cancer", age == '50-69 years')

hist(stomach$deaths.rate)
View(stomach)

# Histograms by age
p <- qplot(dalys.rate, data = health.data, geom = "histogram", binwidth = 1000)
p + facet_wrap(~ age)

p <- qplot(ylls.rate, data = health.data, geom = "histogram", binwidth = 1000)
p + facet_wrap(~ age)

p <- qplot(ylls.rate, data = health.data, geom = "histogram", binwidth = 1000)
p + facet_wrap(~ age)

# YLLs v.s deaths (this should be a very strong correlation)
plot(health.data$deaths.rate, health.data$ylls.rate) # What are those concentrations?
plot(log(health.data$deaths.rate), log(health.data$ylls.rate)) # What are those concentrations?

# Get hovers via plotly
p <- plot_ly(data = health.data, x = ~deaths.rate, y = ~ylls.rate, 
             text = ~paste("Cause: ", cause, '<br>Country:', country))
p

# Choropleth map (see https://plot.ly/r/choropleth-maps/)
# Map only malaria deaths
malaria <- health.data %>% 
            filter(cause == 'Malaria', age=="All Ages", sex=="Male") %>% 
            mutate(deaths.rate = replace(deaths.rate, is.na(deaths.rate), 0))
            
l <- list(color = toRGB("grey"), width = 0.5)
    
# specify map projection/options
g <- list(
  showframe = FALSE,
  showcoastlines = FALSE,
  projection = list(type = 'Mercator')
)

p <- plot_geo(malaria) %>%
  add_trace(
    z = ~deaths.rate, color = ~deaths.rate, colors = 'Blues',
    text = ~country, locations = ~country.code, marker = list(line = l)
  ) %>%
  colorbar(title = '# of malaria deaths') %>%
  layout(
    title = 'Malaria Deahts',
    geo = g
  )

p

# Which diseases cause more disability than years of life lost (aggregate!)
cause.data <- health.data %>% 
              group_by(cause) %>% 
              summarize(deaths = sum(deaths.number), ylls = sum(ylls.number), ylds = sum(ylds.number))

unique(health.data %>% filter(ylds.rate > ylls.rate) %>% select(cause, age))
