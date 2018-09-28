function(input, output, session) {

    pred_supply = reactive(
        if(input$state1 == 'Overall'){0.3*sum(next_week_prediction$Predicted_Neural_Network)}
        else{0.3*sum(next_week_prediction$Predicted_Neural_Network[next_week_prediction$RegionID == input$state1])})
    pred_demand = reactive(
        if(input$state1 == 'Overall'){sum(next_week_prediction$Predicted_Neural_Network)}
        else{sum(next_week_prediction$Predicted_Neural_Network[next_week_prediction$RegionID == input$state1])})

    output$pred_supply <- renderValueBox({
        valueBox(
            value = formatC(pred_supply(), digits = 1, format = "f"),
            subtitle = "Predicted renewable availability for the next week (in MWh)",
            icon = icon("area-chart"),
            color = "green"
        )
    })
    
    output$pred_demand <- renderValueBox({
        valueBox(
            value = formatC(pred_demand(), digits = 1, format = "f"),
            subtitle = "Predicted load for the next week (in MWh)",
            icon = icon("area-chart"),
            color = "green"
        )
    })
    
    output$dygraph1_text <- renderValueBox({
        valueBox(
            subtitle = '',
            value = "Next Week's Load Prediction (in MWh)",
            color = 'blue'
        )
    })

    output$dygraph1 <- renderDygraph(
        if(input$state1 == 'Overall'){
            dataf = next_week_prediction %>% group_by(DateTime) %>% 
                summarise(Predicted_Time_Series = sum(Predicted_Time_Series),Predicted_Neural_Network = sum(Predicted_Neural_Network))
            dataf = xts(dataf[,-1], order.by=dataf$DateTime)
            dygraph(dataf) %>%
                dySeries('Predicted_Neural_Network', label = 'Neural Network') %>%
                dySeries('Predicted_Time_Series', label = 'Time Series') %>%
                dyAxis("y", label = "Load (in MWh)") %>%
                dyAxis("x", label = "Time (Hourly)") %>%
                dyOptions(stackedGraph = F) %>%
                dyRangeSelector(height = 20)}
        else{
            dataf = next_week_prediction %>% filter(RegionID == input$state1)
            dataf = xts(dataf[c(6,7)], order.by=dataf$DateTime)
            dygraph(dataf) %>%
                dySeries('Predicted_Neural_Network', label = 'Neural Network') %>%
                dySeries('Predicted_Time_Series', label = 'Time Series') %>%
                dyAxis("y", label = "Load (in MWh)") %>%
                dyAxis("x", label = "Time (Hourly)") %>%
                dyOptions(stackedGraph = F) %>%
                dyRangeSelector(height = 20)}
    )
    
    output$dygraph2_text <- renderValueBox({
        valueBox(
            subtitle = '',
            value = "Last Week's Load - Actual Vs Predicted (in MWh)",
            color = 'blue'
        )
    })
    
    datainput = reactive({
        historical_data[historical_data$DateTime >= format(input$dateRange1[1]) & historical_data$DateTime <= format(input$dateRange1[2]),]
    })
    output$dygraph2 <- renderDygraph(
        if(input$state2 == 'Overall'){
            dataf2 = datainput() %>% group_by(DateTime) %>% 
                summarise(Predicted_Time_Series = sum(Predicted_Time_Series),Actual = sum(Actual),
                          Predicted_Neural_Network = sum(Predicted_Neural_Network))
            dataf2 = xts(dataf2[c(2,4,3)], order.by=dataf2$DateTime)
            dygraph(dataf2) %>%
                dySeries("Actual", label = "Actual Load") %>%
                dySeries("Predicted_Time_Series", label = "Predicted Time Series") %>%
                dySeries("Predicted_Neural_Network", label = "Predicted Neural Network") %>%
                dyAxis("y", label = "Load (in MWh)") %>%
                dyAxis("x", label = "Time (Hourly)") %>%
                dyOptions(stackedGraph = F) %>%
                dyRangeSelector(height = 20)
        }else{
            dataf2 = datainput() %>% filter(RegionID == input$state2)
            dataf2 = xts(dataf2[c(2,6,7)], order.by=dataf2$DateTime)
            dygraph(dataf2) %>%
                dySeries("Actual", label = "Actual Load") %>%
                dySeries("Predicted_Time_Series", label = "Predicted Time Series") %>%
                dySeries("Predicted_Neural_Network", label = "Predicted Neural Network") %>%
                dyAxis("y", label = "Load (in MWh)") %>%
                dyAxis("x", label = "Time (Hourly)") %>%
                dyOptions(stackedGraph = F) %>%
                dyRangeSelector(height = 20)
        }
    )
    
    output$dygraph3_text <- renderValueBox({
        valueBox(
            subtitle = '',
            value = "Last Week's Renewable Availability - Actual Vs Predicted (in MWh)",
            color = 'blue'
        )
    })
    datainput2 = reactive({
        historical_data[historical_data$DateTime >= format(input$dateRange2[1]) & historical_data$DateTime <= format(input$dateRange2[2]),]
    })
    
    output$dygraph3 <- renderDygraph(        
        if(input$state3 == 'Overall'){
            dataf3 = datainput2() %>% group_by(DateTime) %>% 
                summarise(Predicted_Time_Series = sum(Predicted_Time_Series),Actual = sum(Actual),
                          Predicted_Neural_Network = sum(Predicted_Neural_Network))
            dataf3 = xts(dataf3[c(2,4,3)], order.by=dataf3$DateTime)
            dygraph(dataf3) %>%
                dySeries("Actual", label = "Actual Load") %>%
                dySeries("Predicted_Time_Series", label = "Predicted Time Series") %>%
                dySeries("Predicted_Neural_Network", label = "Predicted Neural Network") %>%
                dyAxis("y", label = "Load (in MWh)") %>%
                dyAxis("x", label = "Time (Hourly)") %>%
                dyOptions(stackedGraph = F) %>%
                dyRangeSelector(height = 20)
        }else{
            dataf3 = datainput2() %>% filter(RegionID == input$state3)
            dataf3 = xts(dataf3[c(2,6,7)], order.by=dataf3$DateTime)
            dygraph(dataf3) %>%
                dySeries("Actual", label = "Actual Load") %>%
                dySeries("Predicted_Time_Series", label = "Predicted Time Series") %>%
                dySeries("Predicted_Neural_Network", label = "Predicted Neural Network") %>%
                dyAxis("y", label = "Load (in MWh)") %>%
                dyAxis("x", label = "Time (Hourly)") %>%
                dyOptions(stackedGraph = F) %>%
                dyRangeSelector(height = 20)
        }
    )

    output$dygraph4_text <- renderValueBox({
        valueBox(
            subtitle = '',
            value = "Daily Data - Energy Met - Maharashtra (in MUs)",
            color = 'blue'
        )
    })
    
    output$dygraph4 <- renderDygraph({
        datam = xts(datam[c(2,3)], order.by=datam$Date)
        dygraph(datam) %>%
            dySeries('Predicted', label = 'Predicted') %>%
            dySeries('Actual', label = 'Actual') %>%
            dyAxis("y", label = "Energy Met (in MUs)") %>%
            dyAxis("x", label = "Time (Daily)") %>%
            dyOptions(stackedGraph = F) %>%
            dyRangeSelector(height = 20)}
    )
}
