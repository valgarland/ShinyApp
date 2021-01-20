#REQUIRED LIBRARIES
library(tidyverse)
library(lubridate)



#ASSIGNED GLOBAL VARIABLES
listings = list.files('./Data/Listings/', pattern = 'csv')
calendars = list.files('./Data/Calendars/', pattern = 'csv')



#FUNCTION DEFINITIONS
#read_files() reads in all of the files mentioned in the files list shown in GLOBAL VARIABLES
read_files =function(files){
  for (i in 1:length(files)){
    new_name = gsub('.csv','',files[i])
    if (substitute(files)=='calendars'){
      assign(new_name,
             read.csv(paste('./Data/Calendars/', files[i], sep='')), 
             envir = .GlobalEnv
             )
    } else {
      assign(new_name,
             read.csv(paste('./Data/Listings/', files[i], sep='')),
             envir = .GlobalEnv
      )
    }
  }
}


#regex_clean() removes everything except numbers
#function requires a vector input - if used in mutate, does not require input
regex_clean = function(x, na.rm = FALSE) str_extract(x, '\\d[\\d,]+')

last_word = function (x) tail(strsplit(x, split=" ")[[1]],1)


#clean_listing() minimally cleans the listing data
clean_listing = function(df){
  require(dplyr)
  df = df %>% select(c(id, name, description, host_response_time, host_response_rate, host_is_superhost, 
                       host_neighbourhood, host_listings_count, host_has_profile_pic, 
                       host_identity_verified, neighbourhood_cleansed, neighbourhood_group_cleansed,
                       latitude, longitude, property_type, room_type, accommodates, beds, amenities, 
                       price, minimum_nights, number_of_reviews, review_scores_rating, instant_bookable,
                       calculated_host_listings_count)) %>%
    mutate_at(c('price', 'host_response_rate'),regex_clean) %>%
    mutate(host_has_profile_pic = ifelse(host_has_profile_pic=='t',1,0),
           property_type=word(property_type, -1))
    }


#clean_calendar() cleans calendar data prior to merging
#function requires the calendar (dataframe name, date from, date to) to complete the cleaning 
clean_calendar = function(df, datefr, dateto){
  require(dplyr)
  require(lubridate)
  df = df %>% 
    mutate(date=parse_date_time(date,orders = 'Ymd')) %>%
    filter(date>=as.Date(datefr) & date<as.Date(dateto)) %>%
    arrange(listing_id) %>%
    group_by(listing_id) %>%
    summarise(unavailable=sum(available=='f'),
              available=sum(available=='t'), 
              total_days=sum(available, unavailable)
              )
  #assign(deparse(substitute(df)), df, envir = .GlobalEnv)
  return(df)
}



#LISTINGS DATA
#Looking at prices, locations, listing type, people accommodated, and general review scores

#File import with read_files() function based on file names shown in GLOBAL VARIABLES
read_files(listings)

listingsDec2018 = clean_listing(listingsDec2018)
listings3Apr2019 = clean_listing(listings3Apr2019)
listings8Jul2019 = clean_listing(listings8Jul2019)
listings14Oct2019 = clean_listing(listings14Oct2019)
listings4Dec2019 = clean_listing(listings4Dec2019)
listings8Apr2020 = clean_listing(listings8Apr2020)
listings7Jul2020 = clean_listing(listings7Jul2020)
listings7Sep2020 = clean_listing(listings7Sep2020)


#Ensuring unique values are kept by repeating anti_join() and full_join() functions
#NOTE: A function could've been written for the section below (or a for loop), although for the sake of
#time, this was brute-forced
listings_diff = anti_join(listingsDec2018, listings3Apr2019, by = 'id')
listings = full_join(listings3Apr2019, listings_diff)

listings_diff = NULL
listings_diff = anti_join(listings, listings8Jul2019, by = 'id')
listings = full_join(listings8Jul2019, listings_diff)

listings_diff = NULL
listings_diff = anti_join(listings, listings14Oct2019, by = 'id')
listings = full_join(listings14Oct2019, listings_diff)

listings_diff = NULL
listings_diff = anti_join(listings, listings4Dec2019, by = 'id')
listings = full_join(listings4Dec2019, listings_diff)

listings_diff = NULL
listings_diff = anti_join(listings, listings8Apr2020, by = 'id')
listings = full_join(listings8Apr2020, listings_diff)

listings_diff = NULL
listings_diff = anti_join(listings, listings7Jul2020, by ='id')
listings = full_join(listings7Jul2020, listings_diff)

listings_diff = NULL
listings_diff = anti_join(listings, listings7Sep2020, by = 'id')
listings = full_join(listings7Sep2020, listings_diff)

listings = listings %>% arrange(id)

#Writing a new listings file for Shiny app works
write.csv(listings, file = 'Airbnb_App/Data/listings.csv', row.names = FALSE)


#CALENDAR DATA
#Looking into availabilities of listings based on calendar data

#Import and clean 2019/2020 calendars
#NOTE: As you'll notice, there was an import of multiple csv files; the reason for this was that all data
#     forward-looking, ie. data downloaded December 2018 is static snapshot in time for data ranging from 
#     December 2018 to December 2019. Since Airbnb listings fluctuate throughout the year, to not have a
#     spike in data every December, quarterly data was downloaded. Each dataset was then cleaned, and fully
#     joined to capture all listings within 2019 and 2020.

#File import with read_files() function based on file names shown in GLOBAL VARIABLES
read_files(calendars)

#Cleaning calendars with user-defined clean_calendar()
calendarDec2018 = clean_calendar(calendarDec2018, '2019-01-01', '2019-04-03') 
calendar3Apr2019 = clean_calendar(calendar3Apr2019, '2019-04-03', '2019-07-08')
calendar8Jul2019 = clean_calendar(calendar8Jul2019, '2019-07-08', '2019-10-14') 
calendar14Oct2019 = clean_calendar(calendar14Oct2019, '2019-10-14', '2020-01-01') 

#Joining the 2019 calendars for a complete year
calendar2019 = full_join(calendarDec2018, calendar3Apr2019)
calendar2019 = full_join(calendar2019, calendar8Jul2019)
calendar2019 = full_join(calendar2019,calendar14Oct2019)

#Final mutation (with included sanity check)
#NOTE: Sanity check looks at total number of days for a listing (should not exceed 365)
calendar2019 = calendar2019 %>%
  group_by(listing_id) %>%
  summarise(available=sum(available), unavailable=sum(unavailable), total_days=sum(total_days))

#Sanity check - if the output is 365, everything was accounted for correctly
max(calendar2019$total_days)

#Adding a "year" column for future full join of yearly data
calendar2019  = mutate(calendar2019, year=year(as.POSIXlt('2019',format = '%Y')))


#Moving on to 2020 import, cleanup, and full join
calendar4Dec2019 = clean_calendar(calendar4Dec2019, '2020-01-01', '2020-04-08') 
calendar8Apr2020 = clean_calendar(calendar8Apr2020, '2020-04-08', '2020-07-07') 
calendar7Jul2020 = clean_calendar(calendar7Jul2020, '2020-07-07', '2020-09-07') 
calendar7Sep2020 = clean_calendar(calendar7Sep2020, '2020-09-07', '2021-01-01') 

#Joining the 2020 calendars for a complete year
calendar2020 = full_join(calendar4Dec2019, calendar8Apr2020)
calendar2020 = full_join(calendar2020, calendar7Jul2020)
calendar2020 = full_join(calendar2020,calendar7Sep2020)

calendar2020 = calendar2020 %>%
  group_by(listing_id) %>%
  summarise(available=sum(available), unavailable=sum(unavailable), total_days=sum(total_days))

#Remove sanity check, add "year" column for future full join of yearly data
calendar2020  = mutate(calendar2020, year=year(as.POSIXlt('2020',format = '%Y')))

#Combining two calendars for full picture data
calendar = full_join(calendar2019,calendar2020)

#Adding average unavailability per year
calendar = calendar %>% 
  mutate(ave_unavailability=round((unavailable/total_days)*100,1),
         id=listing_id) %>%
  mutate(listing_id=NULL) %>%
  select(id, everything()) %>%
  arrange(id)

unique(calendar$id)

#Writing a new calendar file for Shiny app works
write.csv(calendar, file = 'Airbnb_App/Data/calendar.csv', row.names = FALSE)



#COMBINING LISTINGS AND CALENDAR DATA
full_data = merge(listings, calendar, by = 'id', sort = TRUE)

#Split by 2019 and 2020
full_data_2019 = full_data %>% filter(year=='2019')
full_data_2020 = full_data %>% filter(year=='2020')

#Writing a full data file for Shiny app works
write.csv(full_data, file = 'Airbnb_App/Data/full_data.csv', row.names = FALSE)
write.csv(full_data_2019, file = 'Airbnb_App/Data/full_data2019.csv', row.names = FALSE)
write.csv(full_data_2020, file = 'Airbnb_App/Data/full_data2020.csv', row.names = FALSE)

