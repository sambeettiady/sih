rm(list = ls())
library(xts)
library(shinydashboard)
library(dplyr)
library(shiny)
library(tidyr)
library(dygraphs)

output = read.csv(file = 'output_new_1.csv')
datam = read.csv(file = 'India_Data_Actual_Predicted.csv')
datam = datam[datam$State == 'Maharashtra',2:4]
datam = datam[-c(1:3),]
names(datam) = c('Date','Actual','Predicted')
datam$Date = as.POSIXct(strptime(datam$Date, "%d-%m-%Y"))
output = output[!output$RegionID %in% c('SA1','TAS1','QLD1'),]
names(output)[c(7,8)] = c('Predicted_Time_Series','Predicted_Neural_Network')
output = output %>% unite(col = 'DateTime',sep = ' ',remove = T,Date,Time)
output$DateTime = as.POSIXct(strptime(output$DateTime, "%d/%m/%y %H:%M:%S"))
max_date = max(output$DateTime)
output = output[output$DateTime <= (max_date - 24*60*60),]
regvars = as.character(unique(output$RegionID))
max_date = max(output$DateTime)
min_date = min(output$DateTime)
next_week_prediction = output[output$DateTime > (max_date - 7*24*60*60),]
historical_data = output[output$DateTime <= (max_date - 7*24*60*60),]
model_health = ifelse(mean(abs(historical_data$Actual - historical_data$Predicted)) >= 1,'Inspect',ifelse(mean(abs(historical_data$Actual - historical_data$Predicted)) >= 0.4,'Bad','Good'))
next_week = xts(next_week_prediction[c(4:6)], order.by=as.POSIXct(strptime(next_week_prediction[,3], "%Y-%m-%d %H:%M:%S")))
historical_load = xts(historical_data[c(2,6)], order.by=as.POSIXct(strptime(historical_data[,3], "%Y-%m-%d %H:%M:%S")))
#lastweekavailability = xts(last_week_prediction[c(2,4)], order.by=as.POSIXct(strptime(last_week_prediction[,1], "%d/%m/%y %H:%M:%S")))
