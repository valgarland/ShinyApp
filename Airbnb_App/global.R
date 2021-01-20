library(shiny)
library(shinydashboard)
library(DT)
library(dplyr)
library(leaflet)
library(lubridate)
library(plotly)
library(RColorBrewer)

library(ggplot2)

listings_data_2019 = read.csv(file = 'Data/full_data2019.csv', stringsAsFactors = FALSE)
#room_type = c('Private room', 'Entire home/apt', 'Shared room','Hotel room')
colour_scale = colorFactor(palette = 'Spectral', domain = (listings_data_2019$room_type))
