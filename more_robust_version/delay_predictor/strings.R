################
# This file contains declaration of many strings used in the dashboard.

mainHeader <- "Flight Departure Delay Predictor for Newark Airport in NY"

logRegDescription <- "This app will calculate the likelihood of departure delay
               for airlines departing Newark airport in NYC. The app runs
               a Binary Logistic Regression model and uses it to predict
               likelihood of delay."

logRegInstructions <- "The app runs initially with default data, 
               however, once the user changes any of the input values on the left,
               the app refreshes instantly and displays the newly provided values, 
               as well as the likelihood of delay estimate 
               and the refreshed chart with average departure and arrival delay 
               for the chosen airline grouped by month."

basicDecTreeDescription <- "I used the 'tree' R package to run a simple decision tree
               using these variables: year, month, day, carrier,flight, origin, hour, 
              minute, temp,wind, precip, visib, - to predict str_delay value (yes - for 
              delay occurred, and no - for delay didn't occurr). Depending on seed of
              training dataset, the either or both critical factors were hour of departure 
              and visibility."
exampleForecast <- "To help you with providing values for fields above, use this forecast 
                  example:"

C45DecTreeDescription <- "I used the 'Rweka' R package to run a C4.5 decision tree algorithm
               using these variables: year, month, day, carrier,flight, origin, hour, 
              minute, temp,wind, precip, visib, - to predict str_delay value (yes - for 
              delay occurred, and no - for delay didn't occurr). This tree seems to have
              so many branches, that plotting fails. This will need pruning."

CPARTDecTreeDescription <- "I used the 'rpart' R package to run a CPART decision tree algorithm
               using these variables: year, month, day, carrier,flight, origin, hour, 
              minute, temp,wind, precip, visib, - to predict str_delay value (yes - for 
              delay occurred, and no - for delay didn't occurr). This tools shows variable importance
              and seems to have better exploration tools. Because of high cross validation error,
              it will need to be pruned anyway."

