#global.R

library(nycflights13)
require(dplyr)

#get the subset of flights data for Newark airport
daily_flights <- subset(flights, flights$origin == "EWR")
#aggregate the weather dataset for Newark station
daily_weather <- weather %>% filter (origin == "EWR") %>%
  group_by(year, month, day) %>% summarise( 
                       temp = mean(temp, na.rm = TRUE),
                       wind = mean(wind_speed, na.rm = TRUE),
                       precip = sum(precip, na.rm = TRUE),
                       visib = mean(visib, na.rm = TRUE)
  )
#create some random numbers to select rows from daily_flights data set
randomrows <- sample.int(nrow(daily_flights), 50000)
#get the rows and save as a Test data set for the model
daily_flights_test <- daily_flights[randomrows,]
#get rid of unnesessary columns
daily_flights_test <- daily_flights_test[,-c(4,6,7,9,10,12,13,14,15,16)]
#combine the two data sets together
merged <- merge(daily_flights_test, daily_weather)
#add a column that will show whether there was a delay for that flight
merged$delay <- rep(0, nrow(merged))
for (i in 1:nrow(merged)) {
  if (!is.na(merged$dep_delay[i]) &  merged$dep_delay[i]> 0) {
    merged$delay[i] <- 1
  }
}

#get the possible airline values in order to display them in the UI
merged_airlines <- data.frame(carrier = unique(merged$carrier))
merged_airlines <- merge(merged_airlines, airlines)
merged_airlines$name<-as.character(merged_airlines$name)
merged_airlines$carrier<-as.character(merged_airlines$carrier)


#to get the current weather data for Newark Airport 
weatherToday <- weatherData::getSummarizedWeather("KEWR", Sys.Date(), opt_custom_columns=T,
                                     custom_columns = c(3,15,18,20))
weatherToday<- weatherToday[,-1]
names(weatherToday) <- c("temp", "visib", "windspeed","precip" )
weatherToday <- data.frame(Metrics = names(weatherToday), Values = c(weatherToday[1,1],
                           weatherToday[1,2], weatherToday[1,3], weatherToday[1,4]) )
