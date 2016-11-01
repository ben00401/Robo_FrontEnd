library(fPortfolio)
library(mongolite)
library(RJSONIO)

profit <- function(user){
  
  today <-as.Date("2016-01-01")

  user <- fromJSON(user)
  #user ="admin"
  #get user's portfolio form db
  data_portfolio <- mongo(collection = "portfolio" ,db="fund20160414", url = "mongodb://localhost/?sockettimeoutms=1200000")
  user_portfolio <- data_portfolio$find(paste0('{"user" : {"$eq" :"' ,user , '"}}'))
  
  #caculator profit
  profitdata_return <- list()
  
  for (i in 1:nrow(user_portfolio)) {
    profitdata <-calculator(user_portfolio$id[[i]],user_portfolio$date[i],user_portfolio$name[[i]],today)
    
    total_profit <- count_total_profit(profitdata$profitlist,user_portfolio$ratio[[i]])
    #profitdata <- c(list(profitdata = profitdata),list(date = user_portfolio$date[i]),list(total_profit = total_profit))
    #name_profit <- paste0("porfolio",i)
    
    profitdata_return[[i]] <- c(list(key = i),ratio = user_portfolio$ratio[i],list(profitdata = profitdata$profitlist),list(date = user_portfolio$date[i]),list(today = profitdata$todaydate),list(total_profit = total_profit))
  }
  return(toJSON(profitdata_return))
  #================print profit mini-variance
  #mini_variance<-c()
  #for(k in 1:4){
  #  test_profit<-testprofitdf[k,] %*% funddata$mvweight
  #  mini_variance <- append(mini_variance, test_profit)
  #  print(mini_variance)
  #}
  #================print profit max sharpe ratio
  
  #tangency<-c()
  #for(k in 1:4){
  #  test_profit<-testprofitdf[k,] %*% funddata$sharperatioweight
  #  tangency <- append(tangency, test_profit)
  #  print(tangency)
  #}
  
  #================print profit equal weight
  #equalw<-c()
  #for(k in 1:4){
  #  test_profit<-testprofitdf[k,] %*% funddata$eqweight
  #  equalw <- append(equalw, test_profit)
  #  print(equalw)
  #}
  #final_profit <- c(list(mvweight = mini_variance),list(sharperatioweight = tangency),list(eqweight = equalw))
  #toJSON(final_profit)
}

calculator = function(fundid,start_day,fundname,today){
  
  #end_day is 1 year later than start_day
  end_day <- seq(as.Date(start_day), length = 2, by = "13 months")[2]
  #count date
  oneyear <- seq(as.Date(start_day), length = 2, by = "12 months")[2]
  sixmonth <- seq(as.Date(start_day), length = 2, by = "6 months")[2]
  threemonth <- seq(as.Date(start_day), length = 2, by = "3 months")[2]
  onemonth <- seq(as.Date(start_day), length = 2, by = "1 months")[2]
  
  #start calculate
  lastdate <-""
  profitlist <- list()
  for (i in 1:length(fundid)){
    fundcollectionname = fundid[i]
    fund_collection <- mongo(collection = fundcollectionname ,db="fund20160414", url = "mongodb://localhost/?sockettimeoutms=1200000")
    funddata_all <- fund_collection$find()
    colnames(funddata_all)[1] <- "date"
    
    
    
    #get data
    profit_data <-subset(funddata_all,as.Date(funddata_all$date) %in% as.Date(firstDayMonth(funddata_all$date,as.Date(start_day))) & funddata_all$date >= as.Date(start_day) & funddata_all$date < as.Date(end_day) ,select= c(1,2))
    today_data <-subset(funddata_all, funddata_all$date >= as.Date(today) & funddata_all$date < seq(as.Date(today), length = 2, by = "1 months")[2] ,select= c(1,2))
    today_data <-today_data[1,]
    lastdate <-today_data$date
    
    #計算獲利率1m,3m,6m,12m
    if(Sys.Date()>as.Date(oneyear)){
      profit_today <- (today_data$淨值/profit_data$淨值[1])-1
      
      profit_1m <- (profit_data$淨值[2]/profit_data$淨值[1])-1
      
      profit_3m <- (profit_data$淨值[4]/profit_data$淨值[1])-1
      
      profit_6m <- (profit_data$淨值[7]/profit_data$淨值[1])-1
      
      profit_12m <- (profit_data$淨值[13]/profit_data$淨值[1])-1
      
      profitlist[[i]] <- c(list(id = fundid[i]),list(name = fundname[i]),list(start_value = profit_data$淨值[1]),list(netvalue=c(today_data$淨值,profit_data$淨值[2],profit_data$淨值[4],profit_data$淨值[7],profit_data$淨值[13])),list(profit=c(profit_today,profit_1m,profit_3m,profit_6m,profit_12m)))
      
    }else if(Sys.Date()>sixmonth & Sys.Date()<oneyear){
      
      profit_today <- (today_data$淨值/profit_data$淨值[1])-1
      
      profit_1m <- (profit_data$淨值[2]/profit_data$淨值[1])-1
      
      profit_3m <- (profit_data$淨值[4]/profit_data$淨值[1])-1
      
      profit_6m <- (profit_data$淨值[7]/profit_data$淨值[1])-1
      
      profit_12m <- 0
      
      profitlist[[i]] <- c(list(id = fundid[i]),list(name = fundname[i]),list(start_value = profit_data$淨值[1]),list(netvalue=c(today_data$淨值,profit_data$淨值[2],profit_data$淨值[4],profit_data$淨值[7],0)),list(profit=c(profit_today,profit_1m,profit_3m,profit_6m,profit_12m)))
      
    }else if(Sys.Date()>threemonth & Sys.Date()<sixmonth){
      profit_today <- (today_data$淨值/profit_data$淨值[1])-1
      
      profit_1m <- (profit_data$淨值[2]/profit_data$淨值[1])-1
      
      profit_3m <- (profit_data$淨值[4]/profit_data$淨值[1])-1
      
      profit_6m <- 0
      
      profit_12m <- 0
      
      profitlist[[i]] <- c(list(id = fundid[i]),list(name = fundname[i]),list(start_value = profit_data$淨值[1]),list(netvalue=c(today_data$淨值,profit_data$淨值[2],profit_data$淨值[4],0,0)),list(profit=c(profit_today,profit_1m,profit_3m,profit_6m,profit_12m)))
      
    }else if(Sys.Date()>onemonth & Sys.Date()<threemonth){
      profit_today <- (today_data$淨值/profit_data$淨值[1])-1
      
      profit_1m <- (profit_data$淨值[2]/profit_data$淨值[1])-1
      
      profit_3m <- 0
      
      profit_6m <- 0
      
      profit_12m <- 0
      
      profitlist[[i]] <- c(list(id = fundid[i]),list(name = fundname[i]),list(start_value = profit_data$淨值[1]),list(netvalue=c(today_data$淨值,profit_data$淨值[2],0,0,0)),list(profit=c(profit_today,profit_1m,profit_3m,profit_6m,profit_12m)))
      
    
    }else if(Sys.Date()>onemonth){
      profit_today <- (today_data$淨值/profit_data$淨值[1])-1
      
      profit_1m <- 0
      
      profit_3m <- 0
      
      profit_6m <- 0
      
      profit_12m <- 0
      
      profitlist[[i]] <- c(list(id = fundid[i]),list(name = fundname[i]),list(start_value = profit_data$淨值[1]),list(netvalue=c(today_data$淨值,0,0,0,0)),list(profit=c(profit_today,profit_1m,profit_3m,profit_6m,profit_12m)))
      
    }
    
  }
  return(list(profitlist= profitlist,todaydate = lastdate))
}

count_total_profit = function(profitdata,ratio){
  total_profit <-rep(0,length(profitdata[[1]]$profit))
 
  for(i in 1:length(profitdata)){

    count <- profitdata[[i]]$profit*as.numeric(ratio[i])
    total_profit <- total_profit + count
    
  }
  return(total_profit)
}



firstDayMonth=function(x,today)
{           
  x=as.Date(as.character(x))
  day = as.numeric(format(x,format="%d"))
  monthYr = format(x,format="%Y-%m")
  y = tapply(day,monthYr,function(z) getfirstday(z,today) )
  first=as.Date(paste(row.names(y),y,sep="-"))
  as.factor(first)
}

getfirstday=function(z,today){
  if(length(z[z<=as.numeric(format(today,format="%d"))]) != 0){
    return(z[which.max(z[z<=as.numeric(format(today,format="%d"))])])
  }else{
    return(z[which.min(z[z>=as.numeric(format(today,format="%d"))])])
    
  }
}