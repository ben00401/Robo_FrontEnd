library(rmongodb)
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
  profit_5y <- (as.double(data[length(data[,1]),][3]) - as.double(data[1,][3]))/as.double(data[1,][3])*100
  
  #計算三年獲利％數
  subdata <-subset(data,data[,2] > start_3y)
  profit_3y <- (as.double(subdata[length(subdata[,1]),][3]) - as.double(subdata[1,][3]))/as.double(subdata[1,][3])*100
  
  #計算兩年獲利％數
  subdata <-subset(data,data[,2] > start_2y)
  profit_2y <- (as.double(subdata[length(subdata[,1]),][3]) - as.double(subdata[1,][3]))/as.double(subdata[1,][3])*100
  
  #計算一年獲利％數
  subdata <-subset(data,data[,2] > start_1y)
  profit_1y <- (as.double(subdata[length(subdata[,1]),][3]) - as.double(subdata[1,][3]))/as.double(subdata[1,][3])*100
  
  #計算六個月獲利％數
  subdata <-subset(data,data[,2] > start_6m)
  profit_6m <- (as.double(subdata[length(subdata[,1]),][3]) - as.double(subdata[1,][3]))/as.double(subdata[1,][3])*100
  
  #計算三個月獲利％數
  subdata <-subset(data,data[,2] > start_3m)
  profit_3m <- (as.double(subdata[length(subdata[,1]),][3]) - as.double(subdata[1,][3]))/as.double(subdata[1,][3])*100
  
  return(c(profit_3m,profit_6m,profit_1y,profit_2y,profit_3y,profit_5y))
}

#=========================================================================================

# connect to MongoDB
mongo <- mongo.create(host = "localhost")

mongostart <- as.Date("2010-01-01")
end <- as.Date("2016-03-31")
profitdata <- data.frame(name = character(0), profit_3m= numeric(0), profit_6m= numeric(0), profit_1y= numeric(0), profit_2y= numeric(0), profit_3y= numeric(0), profit_5y= numeric(0),stringsAsFactors=FALSE)
count = 0
co = "fundprofile"
con <- mongo(collection = co ,db="fund20160414", url = "mongodb://localhost")
data <- con$find()

for (i in 1:nrow(data)){

    fundname = data[,1][i]
    ns = paste0('fund20160414.',data[,1][i])
    
    checkdata <- mongo.find.one(mongo, ns)
    print(ns)
    if(! is.null(checkdata)){
        x <- mongo.find.all(mongo, ns)
        
    }
}






if(check[[2]] <= start){
  x <- mongo.find.all(mongo, ns,data.frame = TRUE)
  if(x[,2][1]<=start & x[,2][length(x[,1])] >=end){
    subdata<-subset(x,x[,2] > start & x[,2] < as.Date("2016-01-01"))
    #計算4433所需要的績效值
    cal <-calculator4433(subdata)
    profitdata[nrow(profitdata)+1,]<-c(data[,1][i],cal)
    count = count +1
    print(count)
  }else{
    #print("no")
  }
}



#================================================
fundcollection <- mongo(collection = fundname ,db="fund20160414", url = "mongodb://localhost")
x <-fundcollection$find()
if(x[,1][1]<=start & x[,1][length(x[,1])] >=end){
  
  subdata<-subset(x,x[,1] > start & x[,1] < as.Date("2016-01-01"))
  #計算4433所需要的績效值
  cal <-calculator4433(subdata)
  profitdata[nrow(profitdata)+1,]<-c(data[,1][i],cal)
  
}else{
  #print("no")
}