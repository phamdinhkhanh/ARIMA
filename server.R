
library(shiny)
library("tseries")
library(forecast)

#source("D:/Rcode/ARIMA/global.R", local = TRUE)
#data <- read.csv("D:/Rcode/VCB.csv")
function(input,output){
  
  #data <- read.csv("D:/Rcode/VCB.csv")
  output$table <- renderTable({
    head(data)
  })
  
  output$adf <- renderPrint(
     expr = adf.test, env = parent.frame(),quote = FALSE, width = 100, outputArgs = list()
  )
  
  output$p <- renderPlot({
    acf.train = acf(train,main = 'ACF Plot', lag.max = 100)
    })

  output$q <- renderPlot({
    pacf.train = pacf(train,main = "PACF plot", lag.max = 100)
    })

  
  output$forecast <- renderTable({
    removeData()
    removeData("D:/Rcode/ARIMA/response/Forecasted_series")
    #Lay gia tri date truoc ngay co stt a
    #Actual_series = xts(0,as.Date("2017-03-23","%Y-%m-%d"))
    #Khởi tạo dataframe của chuỗi forecast
    #forecasted_series = data.frame(STT = integer(),Forecasted = numeric(),Upper_Forecasted = numeric(),Lower_Forecasted = numeric())
    for(b in a:nrow(stock)-1){
      stock_train = stock[1:b,]
      stock_test = stock[-row(stock_train),]
      #Summary ARIMA model
      fit = arima(stock_train,order = c(input$p,0,input$q),include.mean = FALSE)
      #summary(fit$model)
      #Plotting residual plot
      #acf(fit$residuals,main="Residuals plot")
      #Forecast log returns
      #library(forecast)
      arima.forecast = forecast.Arima(fit,h=1,level = 95)
      #summary(arima.forecast$mean)
      #print(arima.forecast$mean)
      #Thêm giá trị dự báo vào chuỗi forecasted_series
      newforecast <- c(STT = b+1,Forecasted = arima.forecast$mean[1],arima.forecast$upper,arima.forecast$lower)
      saveData(newforecast,"D:/Rcode/ARIMA/response/Forecasted_series")
      #forecasted_series <- rbind(forecasted_series,newforecast)
      
      #Plotting the forecast
      #par(mfrow=c(1,1))
      #plot(arima.forecast,main = "ARIMA forecast")
      #Tạo ra một chuỗi actual return của giai đoạn dự báo
      Actual_return = stock[(b+1),]
      #Actual_series <- c(Actual_series,xts(Actual_return))
      saveData(xts(Actual_return))
      
      rm(Actual_return)
    }
    
    forecasted_series <- loadData("D:/Rcode/ARIMA/response/Forecasted_series")
    rownames(forecasted_series) <- a:nrow(stock)
    colnames(forecasted_series)=c("ROW","STT","Forecasted","Upper_Forecasted","Lower_Forecasted")
    forecasted_series <- forecasted_series[order(-forecasted_series[,2]),]
    head(forecasted_series)
  })
  
  
  
  
  
}

