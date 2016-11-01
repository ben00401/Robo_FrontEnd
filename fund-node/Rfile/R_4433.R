library(fPortfolio)


# function區====================================================================

#計算4433
calculator4433 <- function(data){
  start_5y <- as.Date("2010-01-01")
  start_1y <- as.Date("2014-01-01")
  start_2y <- as.Date("2013-01-01")
  start_3y <- as.Date("2012-01-01")
  start_6m <- as.Date("2014-07-01")
  start_3m <- as.Date("2014-10-01")
  end <- as.Date("2016-01-01")
  
  #計算五年獲利％數
  profit_5y <- (as.double(data[length(data$日期),][2]) - as.double(data[1,][2]))/as.double(data[1,][2])*100
  
  #計算三年獲利％數
  subdata <-subset(data,data$日期 > start_3y)
  profit_3y <- (as.double(subdata[length(subdata$日期),][2]) - as.double(subdata[1,][2]))/as.double(subdata[1,][2])*100
  
  #計算兩年獲利％數
  subdata <-subset(data,data$日期 > start_2y)
  profit_2y <- (as.double(subdata[length(subdata$日期),][2]) - as.double(subdata[1,][2]))/as.double(subdata[1,][2])*100
  
  #計算一年獲利％數
  subdata <-subset(data,data$日期 > start_1y)
  profit_1y <- (as.double(subdata[length(subdata$日期),][2]) - as.double(subdata[1,][2]))/as.double(subdata[1,][2])*100
  
  #計算六個月獲利％數
  subdata <-subset(data,data$日期 > start_6m)
  profit_6m <- (as.double(subdata[length(subdata$日期),][2]) - as.double(subdata[1,][2]))/as.double(subdata[1,][2])*100
  
  #計算三個月獲利％數
  subdata <-subset(data,data$日期 > start_3m)
  profit_3m <- (as.double(subdata[length(subdata$日期),][2]) - as.double(subdata[1,][2]))/as.double(subdata[1,][2])*100
  
  return(c(profit_3m,profit_6m,profit_1y,profit_2y,profit_3y,profit_5y))
}



#找出每個月的第一天
firstDayMonth=function(x)
{           
  x=as.Date(as.character(x))
  day = format(x,format="%d")
  monthYr = format(x,format="%Y-%m")
  y = tapply(day,monthYr, min)
  first=as.Date(paste(row.names(y),y,sep="-"))
  as.factor(first)
}
# function區===========================================================================

#抓取資料
filenames <- list.files("/home/dk/Desktop/sharedfolders/Home/Desktop/論文相關/data0414/", pattern = ".csv")
profitdata <- data.frame(name = character(0), profit_3m= numeric(0), profit_6m= numeric(0), profit_1y= numeric(0), profit_2y= numeric(0), profit_3y= numeric(0), profit_5y= numeric(0),stringsAsFactors=FALSE)
count = 0
for (i in 1:length(filenames)){
  path = paste("/home/dk/Desktop/sharedfolders/Home/Desktop/論文相關/data0414/",filenames[i],sep="")
  assign(paste("data",i,sep=""),read.csv(path, header=TRUE, sep=",",colClasses = c("Date","numeric","factor","factor")))
  x <- get(paste("data",i,sep=""))
  start <- as.Date("2010-01-01")
  end <- as.Date("2016-03-31")
  #print(filenames[i])
  #判斷是否有介於2010年1月到2016年3月的資料
  if(x$日期[1]<=start & x$日期[length(x$日期)] >=end){
    
    subdata<-subset(x,x$日期 > start & x$日期 < as.Date("2016-01-01"))
    #計算4433所需要的績效值
    cal <-calculator4433(subdata)
    profitdata[nrow(profitdata)+1,]<-c(filenames[i],cal)
    count =count +1
  }
  else{
    #print("no")
  }
}
print(count)
profitdata$rank_3m[order(as.numeric(profitdata$profit_3m),decreasing = TRUE)] <- 1:nrow(profitdata)
profitdata$rank_6m[order(as.numeric(profitdata$profit_6m),decreasing = TRUE)] <- 1:nrow(profitdata)
profitdata$rank_1y[order(as.numeric(profitdata$profit_1y),decreasing = TRUE)] <- 1:nrow(profitdata)
profitdata$rank_2y[order(as.numeric(profitdata$profit_2y),decreasing = TRUE)] <- 1:nrow(profitdata)
profitdata$rank_3y[order(as.numeric(profitdata$profit_3y),decreasing = TRUE)] <- 1:nrow(profitdata)
profitdata$rank_5y[order(as.numeric(profitdata$profit_5y),decreasing = TRUE)] <- 1:nrow(profitdata)


#result4433<-subset(profitdata,profitdata$rank_1y <= nrow(profitdata)/4 & profitdata$rank_2y <= nrow(profitdata)/4 & profitdata$rank_3y <= nrow(profitdata)/4 & profitdata$rank_5y <= nrow(profitdata)/4 & profitdata$rank_3m <= nrow(profitdata)/3 & profitdata$rank_6m <= nrow(profitdata)/3)
# 因為4433有321筆  所以先用前100名
result4433<-subset(profitdata,profitdata$rank_1y <= 1/4 & profitdata$rank_2y <= 1/4 & profitdata$rank_3y <= 1/4 & profitdata$rank_5y <= 1/4 & profitdata$rank_3m <= 1/3 & profitdata$rank_6m <= 1/3)
#month_profit <- data.frame()

mylist <- list() #create an empty list
for (i in 1:nrow(result4433)){
  print(result4433$name[i])
  path = paste("/home/dk/Desktop/sharedfolders/Home/Desktop/論文相關/data0414/",result4433$name[i],sep="")
  assign(paste("data",i,sep=""),read.csv(path, header=TRUE, sep=",",colClasses = c("Date","numeric","factor","factor")))
  data4433 <- get(paste("data",i,sep=""))
  newdata4433 <-subset(data4433,data4433$日期 %in% as.Date(firstDayMonth(data4433$日期)) & data4433$日期 > as.Date("2010-01-01") & data4433$日期 < as.Date("2015-02-01") ,select= c(1,2))
  newdata4433$net_nextday <- c(newdata4433[,2][2:nrow(newdata4433)],0)
  #計算每月獲利率
  newdata4433 <- within(newdata4433, profit <-(net_nextday/淨值)-1)
  print(newdata4433)
  
  #將4433算完的结果放到LIST中
  vec <- numeric(nrow(newdata4433)-1)
  for(m in 1:nrow(newdata4433)-1){
    #fill the vector
    vec[m]<-newdata4433[,4][m]
  }
  
  #put all vectors in the list
  mylist[[i]] <- vec
}
df <- do.call("cbind",mylist)
print(df)

# fPortfolio specification: solver and efficient fronier
spec <- portfolioSpec()
setSolver(spec) <- "solveRquadprog"
setNFrontierPoints(spec) <- 10000
setRiskFreeRate(spec)<-0.0067

# fPortfolio constraints
constraints <- c("LongOnly")
portfolioConstraints(as.timeSeries(df), spec, constraints)

frontier <- portfolioFrontier(as.timeSeries(df), spec, constraints)
print(frontier)


# plot efficient frontier
#tailoredFrontierPlot(object = frontier)
png(file="myplot.png")



frontierPlot(frontier, 
             pch = 19,
             cex = 0.5,
            )
grid()
abline(h = 0, col = "grey30")
abline(v = 0, col = "grey30")
monteCarloPoints(frontier, mcSteps = 500, pch = 19,
                 cex = 0.3)
t <- tangencyPoints(frontier, pch = 19, col = "blue")
tangencyLines(frontier, col = "darkblue",lwd=3)
eq <- equalWeightsPoints(frontier, pch = 19, col = "green")
minpoint <- minvariancePoints(frontier, pch = 19, col = "red")


z <- sharpeRatioLines(frontier, col = "orange", lwd = 2)
dev.off()
getwd()
# 計算效益 ===========================================================================
#max sharpe ratio's weight
index <-which.min(abs(frontier@portfolio@portfolio[[3]][,1]-t[2]))

sharperatioweight <- frontier@portfolio@portfolio[[1]][index,]
sharperatioweight

frontier@portfolio@portfolio[[6]]@portfolio@portfolio[[1]][8]
testprofitlist <- list() #create an empty list
for (i in 1:nrow(result4433)){
  path = paste("/home/dk/Desktop/sharedfolders/Home/Desktop/論文相關/data0414/",result4433$name[i],sep="")
  assign(paste("data",i,sep=""),read.csv(path, header=TRUE, sep=",",colClasses = c("Date","numeric","factor","factor")))
  data4433 <- get(paste("data",i,sep=""))
  testprofit_data <-subset(data4433,data4433$日期 %in% as.Date(firstDayMonth(data4433$日期)) & data4433$日期 > as.Date("2015-01-01") & data4433$日期 < as.Date("2016-02-01") ,select= c(1,2))
  testprofit_data$net_nextday <- c(testprofit_data[,2][2:nrow(testprofit_data)],0)
  print(testprofit_data)
  #計算獲利率
  #testprofit <- within(testprofit_data, profit <-(net_nextday/淨值)-1)
  testprofit_1m <- (testprofit_data$淨值[2]/testprofit_data$淨值[1])-1
  
  testprofit_3m <- (testprofit_data$淨值[4]/testprofit_data$淨值[1])-1
  
  testprofit_6m <- (testprofit_data$淨值[7]/testprofit_data$淨值[1])-1
  
  testprofit_12m <- (testprofit_data$淨值[13]/testprofit_data$淨值[1])-1
  
  #將PROFIT算完的结果放到LIST中
  testprofitvec <- numeric(4)
  #for(m in 1:nrow(testprofit)-1){
    #fill the vector
  testprofitvec[1]<-testprofit_1m
  testprofitvec[2]<-testprofit_3m
  testprofitvec[3]<-testprofit_6m
  testprofitvec[4]<-testprofit_12m
  #}
  
  #put all vectors in the list
  testprofitlist[[i]] <- testprofitvec 
  
}
#合併成為testprofit 1m,3m,6m,12m的dataframe
testprofitdf <- do.call("cbind",testprofitlist)
print(testprofitdf)

#minimal variance's weight
frontier@portfolio@portfolio[[6]]@portfolio@portfolio[[1]]
testprofitdf[4,] %*% frontier@portfolio@portfolio[[6]]@portfolio@portfolio[[1]]
length(testprofitdf[1,])
sum = 0
#for(k in 1:length(testprofitdf[1,])){
#  sum = sum + (testprofitdf[2,][k]*frontier@portfolio@portfolio[[6]]@portfolio@portfolio[[1]][k])
#  sum = sum + (testprofitdf[4,][k]*sharperatioweight[k])
#   }
#print(sum)

#================print profit mini-variance

for(k in 1:4){
  test_profit<-testprofitdf[k,] %*% frontier@portfolio@portfolio[[6]]@portfolio@portfolio[[1]]
  
  print(test_profit)
}

#================print profit max sharpe ratio

for(k in 1:4){
  test_profit<-testprofitdf[k,] %*% sharperatioweight
  print(test_profit)
}

#================print profit equal weight
eqweight <- rep(1/nrow(result4433[1]),nrow(result4433[1]))
for(k in 1:4){
  test_profit<-testprofitdf[k,] %*% eqweight
  print(test_profit)
}
#================get fund name
path = ("/home/dk/Desktop/sharedfolders/Home/Desktop/論文相關/result4433_100data.csv")

funddata <-read.csv(path, header=TRUE, sep=",",encoding="UTF-8",stringsAsFactors=FALSE)
fundfilename <- gsub(".csv", ":FO", result4433$name)
fund4433_data <-subset(funddata,funddata$id %in% fundfilename ,select= c(1,2))
write.csv(fund4433_data, "data.csv", row.names=FALSE)
fund4433_data$profit_201501_02 <-testprofitdf[1,]
fund4433_data$profit_201501_03 <-testprofitdf[2,]
fund4433_data$profit_201501_06 <-testprofitdf[3,]
fund4433_data$profit_201501_12 <-testprofitdf[4,]
fund4433_data$weight_minvariance <- frontier@portfolio@portfolio[[6]]@portfolio@portfolio[[1]]
fund4433_data$weight_maxsharperatio <- sharperatioweight


newdata4433 <-subset(funddata,as.Date(funddata$X) %in% as.Date(firstDayMonth(as.Date(funddata$X))))
write.csv(newdata4433, "data20160715.csv", row.names=FALSE)
