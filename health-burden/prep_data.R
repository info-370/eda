# Prep data

# Set up
library(tidyr)
library(dplyr)
setwd('~/Documents/info-370/eda/health-burden/')

# Load data
raw.data <- read.csv('./data/raw/ihme-risk-data.csv', stringsAsFactors = FALSE) 

# Population data
pop.data <- read.csv('./data/raw/ihme-pop-data.csv', stringsAsFactors = FALSE) %>% 
                filter(year == 2015) %>% 
                select(pop, location_id, sex_id, age_group_id) %>% 
                rename(age_id = age_group_id)

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
           left_join(pop.data, by=c('location_id', 'sex_id', 'age_id')) %>% 
           select(location_name, location_code, super.region, region, sex_name, rei_name, age_name, pop, val)

# Rename risks
prepped$rei_name <- tolower(prepped$rei_name)
prepped[grepl('meat', prepped$rei_name),'rei_name'] <- 'high.meat'
prepped[grepl('physical', prepped$rei_name),'rei_name'] <- 'low.exercise'
prepped[grepl('alcohol', prepped$rei_name),'rei_name'] <- 'alcohol.use'
prepped[grepl('drug', prepped$rei_name),'rei_name'] <- 'drug.use'

# Reshape
wide.data <- spread(prepped, rei_name, val) %>% 
              rename(country = location_name, country.code = location_code, sex = sex_name, age = age_name) %>% 
              filter(sex != "Both", age != "All Ages") %>% 
              mutate(sex = tolower(sex))

# Write data
write.csv(wide.data, "./data/prepped/risk-data.csv", row.names = FALSE)

