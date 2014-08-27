delay_predictor
===============

Repository with files for shiny app "delayPredictor": http://conniez.shinyapps.io/delayPredictor/

Due to an error that was noticed today Aug 26th, around 8pm, I'm adding this README file with lines of code I had to fix.


```
In global.R

#to get the current weather data for Newark Airport 
#load a static dataset with data obtained from weatherData package

weatherToday <- read.csv("data/weatherToday.csv")

#because dplyr package was throwing an error as well, I changed to "plyr" package function ddply
#get the subset of flights data for Newark airport
daily_flights <- read.csv("data/daily_flights.csv")
#aggregate the weather dataset for Newark station
daily_weather <- subset(weather, weather$origin == "EWR")
daily_weather <- ddply(daily_weather, .(year, month, day), summarise,  
                       temp = mean(temp, na.rm = TRUE),
                       wind = mean(wind_speed, na.rm = TRUE),
                       precip = sum(precip, na.rm = TRUE),
                       visib = mean(visib, na.rm = TRUE)
  )
  
In server.R

#because dplyr package was throwing an error as well, I changed to "plyr" package function ddply
delayData <- subset(daily_flights[,c(2,5,7,8)], daily_flights$carrier == chosenAirline())
      delayData <- ddply(delayData, .(month) , summarise, 
                       DepartureDelay = round(mean(dep_delay, na.rm = TRUE)),
                       ArrivalDelay = round(mean(arr_delay, na.rm = TRUE))
      )
```
