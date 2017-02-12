#server.R

library(shiny)
require(dplyr)
require(tidyr)
library(rCharts)
library(tree)
library(RWeka)
library(partykit)
library(rpart)
library(C50)

#all the data is loaded in global.R file


shinyServer( function(input, output) {
  #create the binary logistic regression model
  glmfit <- glm(delay ~ carrier + visib + precip + wind + 
                  temp, data = merged, family = binomial)
  
  tree_model <- tree(str_delay~., daily_flights_train_tree)
  C45fit <- J48(str_delay~., data=daily_flights_train_tree)
  CPARTfit <- rpart(str_delay ~ .,
                    method="class", data=daily_flights_train_tree)
  C50fit <- C5.0(str_delay~., data=daily_flights_train_tree, trials=10)
  
  
  chosenAirline <- reactive({
    as.character(subset(airlines$carrier, airlines$name == input$airline))
  })
  
  output$predictionData <- renderTable({
      # Compose data frame of prediction values, provided by user
      data.frame(metrics = c("Chosen Airline", "Temperature",
                                      "Precipitation", "Wind Speed", 
                                      "Visibility"),
                          values = c(input$airline, input$temp, input$precip, 
       input$wind, input$visib), stringsAsFactors = FALSE)
      
  })
  
  #function that creates the prediction result based on the glm model
  predictionR<-reactive({
    prediction <- predict.glm(glmfit, newdata = data.frame(carrier = chosenAirline(),
                                                           temp = input$temp, precip = input$precip, 
                                                           wind =input$wind, visib = input$visib),
                          type="response", se.fit=TRUE)
    round(prediction$fit*100)
  })
  
  confintervalR <- reactive({
    #in order to get a confidence interval for the estimate of probability of delay 
    l.hat = predict.glm(glmfit, newdata = data.frame(carrier = chosenAirline(),
                                                     temp = input$temp, precip = input$precip, 
                                                     wind =input$wind, visib = input$visib), se.fit=TRUE)
    ci = c(l.hat$fit - 1.96*l.hat$se.fit, l.hat$fit + 1.96*l.hat$se.fit)
    
    #To transform the results to probabilities type:
    exp(ci)/(1+exp(ci))
  })
  
  #this is passed to the screen to display the prediction likelihood
  output$predictionValue <- renderText({
    paste0("The estimated probability of delay is: ", predictionR(), "%", " with 
           95% confidence interval of (", round(confintervalR()[1]*100), "%, ", round(confintervalR()[2]*100), "%)")
  })
  
  #today's forecast
  output$todaysForecast <- renderTable({
    # Compose data frame
    weatherToday
  })
  
  #chart displaying average departure and arrival delay 
  #for the specified airline grouped by month
  output$delayChart <- renderChart({
    delayData <- daily_flights[,c("month", "carrier", "dep_delay", "arr_delay")] %>% filter(carrier == chosenAirline()) %>% 
      group_by(month) %>% summarise( 
                       DepartureDelay = round(mean(dep_delay, na.rm = TRUE)),
                       ArrivalDelay = round(mean(arr_delay, na.rm = TRUE))
      )
    delayData <- gather(delayData, type, delay, -month)
        
    delayPlot <- hPlot(delay ~ month, data = delayData, group = "type", type = "column",
                       title = paste0("Average Departure and Arrival Delay by Month for ", 
                                      input$airline), subtitle = "negative delay means flight left early")
    delayPlot$xAxis(title = list(text = "Month of Year"), tickInterval = 1)
    delayPlot$addParams(dom = "delayChart")
    return(delayPlot)
  })
  
  
  output$decisionTree1 <- renderPrint({
    
    summary(tree_model)
  })
  
  output$decisionTree1graph <- renderPlot({
    plot(tree_model)
    text(tree_model, pretty=0)
  })
  
  output$decisiontTree1Pred <- renderPrint({
    tree_pred <- predict(tree_model, daily_flights_test_tree, type="class")
    percent_error <-  mean(tree_pred != daily_flights_test_tree$str_delay)
    paste0("Percent of error in prediciton: ", round(percent_error,3), "%.")
  })
  
  output$decisionTree2 <- renderPrint({
    summary(C45fit)
  })
  
  # output$decisionTree2graph <- renderPlot({
  #   plot(C45fit)
  # })
  
  output$decisiontTree2Pred <- renderPrint({
    C45predictions <- predict(C45fit, daily_flights_test_tree)
    # summarize accuracy
    percent_error <- mean(C45predictions != daily_flights_test_tree$str_delay)
    paste0("Percent of error in prediciton: ", round(percent_error,3), "%.")
  })
  
  output$decisionTree3 <- renderPrint({
    printcp(CPARTfit)
  })
  
  output$decisionTree3graph <- renderPlot({
    plot(CPARTfit, uniform=TRUE, margin = 0.08)
    text(CPARTfit, use.n=TRUE, cex=.9)
  })
  
  output$decisionTree3varimportance <- renderPlot({
    summary <- summary(CPARTfit)
    barplot(summary$variable.importance, main="Var Importance",cex.names=0.8)
  })
  output$decisiontTree3Pred <- renderPrint({
    CPARTpredictions <- predict(CPARTfit, daily_flights_test_tree, type = "class")
    percent_error <- mean(CPARTpredictions != daily_flights_test_tree$str_delay)
    paste0("Percent of error in prediciton: ", round(percent_error,3), "%.")
    
  })
  
  output$meanDelayByHour <- renderPlot({
    delayData <- daily_flights[,c("hour", "dep_delay")]  %>% 
      group_by(hour) %>% summarise( 
        DepartureDelay = round(mean(dep_delay, na.rm = TRUE)))
    barplot(delayData$DepartureDelay, main="Mean Delay by Hour",cex.names=0.8)
  })
  
  output$decisionTree4 <- renderPrint({
    print(C50fit)
  })
  
  output$decisionTree4graph <- renderPlot({
    varImp <- as.data.frame(C5imp(C50fit))
    varImp$var <- row.names(varImp)
    
    
    C50fitpruned <- C5.0(str_delay~., data=daily_flights_train_tree[,c("str_delay",varImp$var[1:3])], control = C5.0Control(CF= 0.05), trials=10)
    plot(C50fitpruned, main = "Decision Tree C5.0")
    
  })
  
  output$decisionTree4varimportance <- renderPlot({
    varImp <- as.data.frame(C5imp(C50fit))
    varImp$var <- row.names(varImp)
    barplot(varImp$Overall,names.arg=varImp$var,  las=2)
  })
  
  output$decisiontTree4Pred <- renderPrint({
    C50predictions <- predict(C50fit, daily_flights_test_tree)
    percent_error <- mean(C50predictions != daily_flights_test_tree$str_delay)
    paste0("Percent of error in prediciton: ", round(percent_error,3), "%.")
    
  })

  
})