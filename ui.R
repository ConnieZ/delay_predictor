#ui.R
library(shiny)
library(rCharts)

shinyUI(fluidPage(
  titlePanel("Flight Departure Delay Predictor for Newark Airport in NY"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("This app will calculate the likelihood of departure delay
               for airlines departing Newark airport in NYC. The app runs
               a Binary Logistic Regression model and uses it to predict
               likelihood of delay."),
      #input controls
      selectInput("airline", label = strong("Choose an airline"), 
                  choices = merged_airlines$name,
                  selected = merged_airlines$name[1]),
      numericInput("temp", label = strong("Specify the temperature (degrees Fahrenheit)"), 
                   value = 75),
      numericInput("precip", label = strong("Specify the precipitation (inches)"), 
                   value = 0),
      numericInput("wind", label = strong("Specify the wind speed (mph)"), 
                   value = 5),
      numericInput("visib", label = strong("Specify the visibility"), 
                   value = 10),
      h5("To help you with providing values for fields above, use this forecast for weather in Newark, NY today:"),
      tableOutput("todaysForecast")
      
    ),
    
    mainPanel(
      h4("Instructions"),
      helpText("The app runs initially with default data, 
               however, once the user changes any of the input values on the left,
               the app refreshes instantly and displays the newly provided values, 
               as well as the likelihood of delay estimate 
               and the refreshed chart with average departure and arrival delay 
               for the chosen airline grouped by month."),
      h4("The values you provided for prediction model:"),
      tableOutput("predictionData"),
      br(),
      textOutput("predictionValue"),
      br(),
      div(class='wrapper',
          tags$style(".highcharts{ height: 100%; width: 800px;}"),showOutput('delayChart', 'highcharts'))
      )
    
  )
))