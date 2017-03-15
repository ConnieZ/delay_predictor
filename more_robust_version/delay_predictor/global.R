#global.R
# install.packages("nycflights13")
# install.packages("dplyr")
# install.packages("weatherData")
# install.packages("tidyr")
# install.packages("neuralnet")

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
#leave only necessary columns
daily_flights <- daily_flights[,c("year", "month", "day", "dep_time", "dep_delay", "arr_delay", "carrier",
                     "flight", "tailnum", "origin", "dest", "hour", "minute")]

#combine the two data sets together
daily_flights <- merge(daily_flights, daily_weather, by = c("year", "month", "day"))

#add a column that will show whether there was a delay for that flight
daily_flights <- mutate(daily_flights, 
                        delay = ifelse(!is.na(dep_delay) &  dep_delay> 0, 1, 0))


#add a string column that will show whether there was a delay for that flight
daily_flights <- mutate(daily_flights, 
                        str_delay = ifelse(!is.na(dep_delay) &  dep_delay> 0, "yes", "no"))


# split data into testing and training 
set.seed(3)
train <- sample(1:nrow(daily_flights), nrow(daily_flights)*0.65)
test <- -train
# randomrows <- sample.int(nrow(daily_flights), 50000)
#get the rows and save as a train data set for the model
daily_flights_train <- daily_flights[train,]
daily_flights_test <- daily_flights[test,]

merged <- daily_flights_train


#get the possible airline values in order to display them in the UI
merged_airlines <- data.frame(carrier = unique(merged$carrier))
merged_airlines <- merge(merged_airlines, airlines)
merged_airlines$name<-as.character(merged_airlines$name)
merged_airlines$carrier<-as.character(merged_airlines$carrier)


#to get the current weather data for Newark Airport 
# unfortunately, you have to provide column numbers and not column names
if(is.na(weatherData::getSummarizedWeather("KEWR", Sys.Date())[1])){
  weatherToday <- data.frame(Metrics = c("temp", "visib", "windspeed","precip" ),
                             Values = c(75, 10, 0, 0))
} else{
  weatherToday <- weatherData::getSummarizedWeather("KEWR", Sys.Date(), opt_custom_columns=T,
                                                    custom_columns = c(3,15,18,20))
  weatherToday<- weatherToday[,-1]
  names(weatherToday) <- c("temp", "visib", "windspeed","precip" )
  weatherToday <- data.frame(Metrics = names(weatherToday), Values = c(weatherToday[1,1],
                                                                       weatherToday[1,2], weatherToday[1,3], weatherToday[1,4]) )
}



# install.packages("tree")
library(tree)

# delay var is the one we will be predicting
daily_flights_train_tree <- daily_flights_train
daily_flights_train_tree$carrier<- as.factor(daily_flights_train_tree$carrier)
daily_flights_train_tree$str_delay<- as.factor(daily_flights_train_tree$str_delay)

# because dest and tailnum vars have more than 32 levels we need to remove them

# this revealed that dep_time is highly correlated with overall delay 
# let's see if we remove it, what happens

daily_flights_train_tree <- daily_flights_train_tree[,c("year", "month", "day", "carrier",
                                                        "flight", "hour", "minute", "temp",
                                                        "wind", "precip", "visib", "str_delay")]  
# Datasets for Artificial Neural Networks 
daily_flights_ann <- daily_flights
carrier_map <- data.frame(carrier = sort(unique(daily_flights$carrier)), 
                         carrier_int = seq_along(sort(unique(daily_flights$carrier))))
daily_flights_ann <- merge(daily_flights_ann, carrier_map, by="carrier", all.x=TRUE)
daily_flights_ann <- daily_flights_ann[,c("year", "month", "day", "carrier_int",
      "flight", "hour", "minute", "temp",
      "wind", "precip", "visib", "delay")]

train_ann <- sample(1:nrow(daily_flights), nrow(daily_flights)*0.20)
test_ann <- -train_ann
daily_flights_train_ann <- daily_flights_ann[train_ann,]
daily_flights_test_ann <- daily_flights_ann[test_ann,]


# plot(tree_model)
# text(tree_model, pretty=0)

# tree_model$frame

# time of departure and visibility are usually the two main classifiers, depending on sampling seed


daily_flights_test_tree <- daily_flights_test
daily_flights_test_tree$carrier<- as.factor(daily_flights_test_tree$carrier)
daily_flights_test_tree$str_delay<- as.factor(daily_flights_test_tree$str_delay)
daily_flights_test_tree <- daily_flights_test_tree[,c("year", "month", "day", "dep_time", "arr_delay", "carrier",
                                                      "flight", "hour", "minute", "temp",
                                                      "wind", "precip", "visib", "str_delay")] 

