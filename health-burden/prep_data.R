# Prep data

# Set up
library(tidyr)
library(dplyr)
setwd('~/Documents/info-370/eda/health-burden/')

# Load data
raw.data <- read.csv('./data/raw/ihme-disease-burden.csv', stringsAsFactors = FALSE)

# Load hierarchy of locations to exclude estimates at aggregate levels
location.hierarchy <- read.csv('./data/raw/location-hierarchy.csv', stringsAsFactors = FALSE) %>% 
                        filter(level == 3) %>% # only country level
                        select(location_id, location_name, location_code)

location.names <- read.csv('./data/raw/location-names.csv', stringsAsFactors = FALSE) %>% 
                rename(location_name = Location, super.region = Super.Region, region = Region) %>% 
                select(location_name, location_id, super.region, region)

locations <- left_join(location.hierarchy, location.names, by='location_id')

# Merge data, exclude missing locations
prepped <- left_join(locations, raw.data, by='location_id') %>% 
              rename(metric = measure_name) %>% 
              mutate(unit = tolower(metric_name)) %>%
              select(location_name, location_code, super.region, region, metric, unit, sex_name, cause_name, age_name, val)
              

# Rename metric
prepped$metric <- tolower(prepped$metric)
prepped[grepl('daly', prepped$metric),'metric'] <- 'dalys'
prepped[grepl('yll', prepped$metric),'metric'] <- 'ylls'
prepped[grepl('yld', prepped$metric),'metric'] <- 'ylds'

# Create metric-unit column
prepped <- prepped %>% 
              mutate(metric.unit = paste(metric, unit, sep=".")) %>% 
              select(location_name, location_code, super.region, region, sex_name, cause_name, age_name, val, metric.unit)

# Reshape
wide.data <- spread(prepped, metric.unit, val) %>% 
              rename(country = location_name, country.code = location_code, sex = sex_name, cause = cause_name, age = age_name)

# Write data
write.csv(wide.data, "./data/prepped/burden-data.csv", row.names = FALSE)
