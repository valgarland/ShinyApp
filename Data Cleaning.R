library(tidyverse)
library(lubridate)

listings = read.csv("./Data/listings.csv", stringsAsFactors = FALSE)
str(listings)
unique(listings$date)

listings = select(listings, -c(listing_url, scrape_id, last_scraped, picture_url,
                               host_url, host_location, host_is_superhost, host_acceptance_rate,
                               host_thumbnail_url, host_picture_url, host_neighbourhood,
                               host_verifications, host_total_listings_count, minimum_minimum_nights,
                               maximum_minimum_nights, minimum_maximum_nights, maximum_maximum_nights,
                               minimum_nights_avg_ntm, maximum_nights_avg_ntm, has_availability, 
                               availability_30, availability_60, availability_90, 
                               bathrooms, calendar_updated, calendar_last_scraped, license, 
                               first_review))

str(listings)


#Looking into availabilities of listings based on calendar data

#Creating a helper function to clean the calendar data
clean_calendar = function(df, yr){
  require(dplyr)
  require(lubridate)
  df <- df %>% mutate(date=parse_date_time(date,orders = 'Ymd')) %>%
    mutate(year=year(date)) %>%
    filter(year==yr) %>%
    arrange(listing_id) %>%
    group_by(listing_id) %>%
    summarise(unavailable=sum(available=='f'), available=sum(available=='t'))
  #assign(deparse(substitute(df)), df, envir = .GlobalEnv)
  return(df)
}


#Import + clean 2019 calendar - this will provide insights for pre-pandemic data
#NOTE: Calendar A only goes up to 05 Dec 2019, thus Calendar B was uploaded to complete the year
#NOTE: a total of 1542 AirBnBs were added from Dec 2018 to Dec 2019 - will affect data join
calendar2019a = read.csv('./Data/calendar2019a.csv', stringsAsFactors = FALSE)
calendar2019b = read.csv('./Data/calendar2019b.csv', stringsAsFactors = FALSE)

calendar2019a = clean_calendar(calendar2019a, '2019')
calendar2019b = clean_calendar(calendar2019b, '2019')

#Joining the two 2019 calendars for a complete year



#Import + clean 2020 calendars - looking at various updates done 
calendar2020 = read.csv('./Data/calendar2019b.csv', stringsAsFactors = FALSE)

calendar2020 = clean_calendar(calendar2020, '2020')

