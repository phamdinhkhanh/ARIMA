library(tseries)
library(xts)



saveData <- function(data,outputDir = "D:/Rcode/ARIMA/response/Actual_series"){
  data <- t(data)
  fileName <- sprintf("%s_%s.csv",as.integer(Sys.time()),
                      digest::digest(data))
  write.csv(x = data,
            file = file.path(outputDir, fileName),
            row.names = TRUE, quote = TRUE
  )
}


loadData <- function(outputDir = "D:/Rcode/ARIMA/response/Actual_series"){
  files <- list.files(outputDir, full.names = TRUE)
  data <- lapply(files, read.csv, stringsAsFactors = FALSE)
  data <- do.call(rbind,data)
  data
}


removeData <- function(outputDir = "D:/Rcode/ARIMA/response/Actual_series"){
  files <- list.files(outputDir,full.names = TRUE)
  do.call(file.remove,list(files))
}

data <- read.csv("D:/Rcode/VCB.csv")
##Tao mau data

data$DATE <- as.Date(data$DATE,format = "%d/%m/%Y")


data.xts <- xts(x = data[,2],order.by = data$DATE)
colnames(data.xts) <- c("Stock_prices")

#tao chuoi loi suat
stock = diff(log(data.xts$Stock_prices), lag = 1)
stock = stock[!is.na(stock)]


breakpoint = floor(nrow(stock)*(2.9/3))
#chia tap train & test
train = stock[1:breakpoint,]
test = stock[-row(train),]


adf.test = adf.test(train)

a = nrow(train)
#stock[a,]
#Lay gia tri date truoc ngay co stt a
Actual_series = xts(0,as.Date("2017-03-23","%Y-%m-%d"))
saveData(Actual_series)
#Actual_series
#Khởi tạo dataframe của chuỗi forecast
forecasted_series = data.frame(STT = integer(),Forecasted = numeric(),Upper_Forecasted = numeric(),Lower_Forecasted = numeric())
#saveData(forecasted_series,outputDir = "D:/Rcode/ARIMA/response/Forecasted_series")
#Điều chỉnh độ dài của chuỗi lợi suất

