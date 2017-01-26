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

