#### Preamble ####
# Purpose: Clean the survey data downloaded from open data toronto
# Author: Owen Huang
# Data: 6 January 2021
# Contact: o.huang@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the ACS data and saved it to inputs/data
# - Don't forget to gitignore it!
# Any other information needed?


#### Workspace setup ####

library(opendatatoronto)
library(dplyr)
library(ggplot2)
library(knitr)
library(kableExtra)
library(hms)

# get package
package <- show_package("64a26694-01dc-4ec3-aa87-ad8509604f50")
package

# get all resources for this package
resources <- list_package_resources("64a26694-01dc-4ec3-aa87-ad8509604f50")

# identify datastore resources; by default, Toronto Open Data sets datastore resource format to CSV for non-geospatial and GeoJSON for geospatial resources
datastore_resources <- filter(resources, tolower(format) %in% c('csv', 'geojson'))

# load the first datastore resource as a sample
data <- filter(datastore_resources, row_number()==1) %>% get_resource()
data

data <- data %>% 
  select(Civilian_Casualties, Estimated_Dollar_Loss, Fire_Under_Control_Time, Method_Of_Fire_Control, Status_of_Fire_On_Arrival, TFS_Alarm_Time, TFS_Arrival_Time, TFS_Firefighter_Casualties)

data <- data %>% mutate(Year = strtrim(TFS_Alarm_Time, 4),
                        Response_Time = ifelse(as_hms(substring(TFS_Arrival_Time, 12, 19)) - as_hms(substring(TFS_Alarm_Time, 12, 19)) < 0, 
                                               as_hms(substring(TFS_Arrival_Time, 12, 19)) - as_hms(substring(TFS_Alarm_Time, 12, 19)) + 86400,
                                               as_hms(substring(TFS_Arrival_Time, 12, 19)) - as_hms(substring(TFS_Alarm_Time, 12, 19))),
                        Time_of_Day = ifelse(as_hms(substring(TFS_Alarm_Time, 12, 19)) >= as_hms("04:00:00") & as_hms(substring(TFS_Alarm_Time, 12, 19)) <= as_hms("12:00:00"), "morning", "night"), 
                        Time_of_Day = ifelse(as_hms(substring(TFS_Alarm_Time, 12, 19)) > as_hms("12:00:00") & as_hms(substring(TFS_Alarm_Time, 12, 19)) <= as_hms("20:00:00"), "afternoon", Time_of_Day))

#### What's next? ####



         