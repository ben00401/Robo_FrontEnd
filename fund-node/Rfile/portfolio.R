library(fPortfolio)
library(mongolite)
library(RJSONIO)

today <- as.Date("2015-01-01")

portfolio <- function(portfolio_fundname){

  #get parameter form front-end
  portfolio_fundname <- fromJSON(portfolio_fundname)
  
  selectedfund_data<-get_selectedfund_data(portfolio_fundname);
  
  calculate_portfolio <- calculate_portfolio(portfolio_fundname = portfolio_fundname,selectedfund_data = selectedfund_data,riskfreerate = 0.0067);
  
  
   toJSON(calculate_portfolio)
  
}


get_selectedfund_data <- function(portfolio_fundname){
  
  mylist <- list() #create an empty list
  for (i in 1:length(portfolio_fundname$portfolio_fundname)){
    
    #get data from mongodb
    fundcollectionname = portfolio_fundname$portfolio_fundname[i]
    
    
    
    data_4433collection <- mongo(collection = fundcollectionname ,db="fund20160414", url = "mongodb://localhost/?sockettimeoutms=1200000")
    
    data4433 <- data_4433collection$find()
    colnames(data4433)[1] <- "date"
    
    #get data for 5 years
    start <- seq(today, length = 2, by = "-5 years")[2]
    
    end <- today
    newdata4433 <-subset(data4433,as.Date(data4433$date) %in% as.Date(firstDayMonth(data4433$date,today)) & data4433$date > start & data4433$date < end ,select= c(1,2))
    
    newdata4433$net_nextday <- c(newdata4433[,2][2:nrow(newdata4433)],0)
    
    #計算每月獲利率
    newdata4433 <- within(newdata4433, profit <-(net_nextday/淨值)-1)
    
    
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
  return(df)
}

calculate_portfolio <- function(portfolio_fundname,selectedfund_data,riskfreerate){
  
  # fPortfolio specification: solver and efficient fronier
  spec <- portfolioSpec()
  setSolver(spec) <- "solveRquadprog"
  setNFrontierPoints(spec) <- 1000
  setRiskFreeRate(spec)<-riskfreerate
  #print(spec)
  
  setwd("/home/dk/nodejs-demo/public/images")
  # fPortfolio constraints
  constraints <- c("LongOnly")
  portfolioConstraints(as.timeSeries(selectedfund_data), spec, constraints)
  
  frontier <- portfolioFrontier(as.timeSeries(selectedfund_data), spec, constraints)
  #print(frontier)
  
  #draw portfolio
  filename=paste0(portfolio_fundname$user,gsub(":","",gsub(" ", "", as.character(Sys.time()))),".png")
  
  
  png(file=filename) 
  
  frontierPlot(frontier, 
               pch = 19,
               cex = 0.5
  )
  grid()
  
  monteCarloPoints(frontier, mcSteps = 500, pch = 19,
                   cex = 0.3)
  t <- tangencyPoints(frontier, pch = 19, col = "blue",cex=1.8)
  tangencyLines(frontier, col = "darkblue",lwd=3)

  eq <- equalWeightsPoints(frontier, pch = 19, col = "green",cex=1.8)
  minpoint <- minvariancePoints(frontier, pch = 19, col = "red",cex=1.8)
  
  tt <- tangencyPortfolio(as.timeSeries(selectedfund_data), spec, constraints)

  
  z <- sharpeRatioLines(frontier, col = "orange", lwd = 2)
 
  #print(z)
  dev.off()
  
  
  #max sharpe ratio's weight
  index <-which.min(abs(frontier@portfolio@portfolio[[3]][,1]-t[2]))
  
  
  sharperatioweight <- frontier@portfolio@portfolio[[1]][index,]
  
  
  #================print profit equal weight
  eqweight <- rep(1/length(portfolio_fundname$portfolio_fundname),length(portfolio_fundname$portfolio_fundname))
  
  #min-var weight
  mvweight <- frontier@portfolio@portfolio[[6]]@portfolio@portfolio[[1]]
  
  #print(sharperatioweight)
  #print(eqweight)
  #print(mvweight)
  #==================================================
  #find the chinese name
  fundprofile <- mongo(collection = "fundprofile" ,db="fund20160414", url = "mongodb://localhost")
  fundprofiledata <- fundprofile$find()
  fundprofiledata <-subset(fundprofiledata,fundprofiledata$id %in% portfolio_fundname$portfolio_fundname)
  #fundprofiledata[,2]
  
  
  
  request <- c(list(sharperatioweight=sharperatioweight),list(eqweight=eqweight),list(mvweight=unname(mvweight)),list(filename = filename),list(name = fundprofiledata[,2]),list(id=portfolio_fundname$portfolio_fundname),list(tangencypoint =c(t[1],t[2])),list(eqpoint = c(eq[1],eq[2])),list(min_varpoint = c(minpoint[1],minpoint[2])))
  return(request)
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