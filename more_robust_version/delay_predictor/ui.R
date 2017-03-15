#ui.R
library(shinydashboard)
library(shiny)
library(rCharts)
source("strings.R")

dashboardPage(
  dashboardHeader(title = "Delay Predictor"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Logistic Regression", tabName = "LR", icon = icon("line-chart")),
      menuItem("Decision Tree", tabName = "DT", icon = icon("cogs")),
      menuItem("Neural Networks", tabName = "ANN", icon = icon("cogs"))
      
    ),
    hr()
  ),
  dashboardBody(
      tabItems(
        # First tab content
        tabItem(tabName = "LR",
                fluidRow(
                  box(width = 12,
                    h3(mainHeader),
                    helpText(logRegDescription)
                  )
                ),
                fluidRow(
                  column(width = 3, 
                     box(width = 12,
                         # input controls
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
                         h5(exampleForecast),
                         tableOutput("todaysForecast")
                      )
                  ),
                  column(width = 9, 
                      box(width = 12,
                         h4("Instructions"),
                         helpText(logRegInstructions),
                         h4("The values you provided for prediction model:"),
                         tableOutput("predictionData"),
                         br(),
                         textOutput("predictionValue"),
                         br(),
                         div(class='wrapper',
                             showOutput('delayChart', 'highcharts'))
                      )
                  )
                )     
            
            ),
        
            # Second tab content
            tabItem(tabName = "DT",
                    h2("Decision Tree Analysis"),
                    fluidRow(
                      column(width = 6, 
                             box(width = 12,
                                 helpText(basicDecTreeDescription),
                                 textOutput("decisionTree1"),
                                 plotOutput("decisionTree1graph"),
                                 textOutput("decisiontTree1Pred")
                             )
                      ),
                      column(width = 6, 
                             box(width = 12,
                                 helpText(C45DecTreeDescription),
                                 textOutput("decisionTree2"),
                                 #plotOutput("decisionTree2graph"),
                                 textOutput("decisiontTree2Pred"),
                                 plotOutput("meanDelayByHour")
                             )
                      )
                      
                    ),
                    fluidRow(
                      column(width = 6, 
                             box(width = 12,
                                 helpText(CPARTDecTreeDescription),
                                 textOutput("decisionTree3"),
                                 textOutput("decisiontTree3Pred"),
                                 plotOutput("decisionTree3varimportance"),
                                 plotOutput("decisionTree3graph")
                                 #,
                                 #
                             )
                      ),
                      column(width = 6, 
                             box(width = 12,
                                 helpText(C50DecTreeDescription),
                                 textOutput("decisionTree4"),
                                 textOutput("decisiontTree4Pred"),
                                 plotOutput("decisionTree4graph"),
                                 plotOutput("decisionTree4varimportance")
                             )
                      )
                      
                    )
                    
            ),
        # Third tab content
        tabItem(tabName = "ANN",
                h2("Artificial Neural Networks"),
                fluidRow(
                  column(width = 6, 
                         box(width = 12,

                             plotOutput("ANNgraph")

                         )
                  )
                  
                )
                  
                
                
        )
        

        )
      )
)