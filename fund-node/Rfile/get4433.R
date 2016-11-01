
library(mongolite)
library(RJSONIO)

today <- as.Date("2015-01-01")

get_result4433 <- function(type){
  
  type <- fromJSON(type)
  
  if(type[[1]]=="4433_100"){
    data_4433_100<-get_4433data(type[[1]],today);
    toJSON(data_4433_100)

  }else if(type[[1]]=="4433"){
    
    data_4433<-get_4433data(type[[1]],today);
    toJSON(data_4433)
  }else if(type[[1]]=="4433_50"){
    
    data_4433_50<-get_4433data(type[[1]],today);
    toJSON(data_4433_50)
  }
}

# if db have today's data just send to front-end
#if there are no data in db then count it
get_4433data<-function(type,today){
  
  
  
  if(type=="4433_100"){
    result4433_100 <- mongo(collection = "result4433_100" ,db="fund20160414", url = "mongodb://140.119.19.21/?sockettimeoutms=1200000")
    print("connecttodb")
    #check mongodb have today's 4433result
    if(result4433_100$count()>0){
      print("checked 4433result100")
      checkdate <-result4433_100$find(limit = 1)
      if(checkdate$date==today){
        
        data4433 <- result4433_100$find();
        
        data4433$name <- iconv(data4433$name,from = "utf8", to = "utf-8")
        
        return(data4433)
        
      }else{
        #got today's 4433result ,then output to front-end
        print("no 4433100 data")
        result_of_count <- count4433(type,today);
        return(result_of_count);
      }
    }else{
      result_of_count<-count4433(type,today);
      return(result_of_count);
    }
    
  }else if(type=="4433"){
    
    result4433 <- mongo(collection = "result4433" ,db="fund20160414", url = "mongodb://140.119.19.21/?sockettimeoutms=1200000")
    
    #check mongodb have today's 4433result
    if(result4433$count()>0){
      
      checkdate <-result4433$find(limit = 1)
      if(checkdate$date==today){
        #got today's 4433result ,then output to front-end
        data4433 <- result4433$find();
        data4433$name <- iconv(data4433$name,from = "utf8", to = "utf-8")
        
        return(data4433)
      }else{
        result_of_count<-count4433(type,today);
        return(result_of_count);
      }
    }else{
      result_of_count<-count4433(type,today);
      return(result_of_count);
    }  
    
  }else if(type =="4433_50"){
    
    
    result4433 <- mongo(collection = "result4433_50" ,db="fund20160414", url = "mongodb://140.119.19.21/?sockettimeoutms=1200000")
    
    #check mongodb have today's 4433result
    if(result4433$count()>0){
      
      checkdate <-result4433$find(limit = 1)
      if(checkdate$date==today){
        #got today's 4433result ,then output to front-end
        data4433 <- result4433$find();
        data4433$name <- iconv(data4433$name,from = "utf8", to = "utf-8")
        return(data4433)
      }else{
        result_of_count<-count4433(type,today);
        return(result_of_count);
      }
    }else{
      result_of_count<-count4433(type,today);
      return(result_of_count);
    }  
    
  }
  
}


count4433 <- function(type,today){
  
  # no 4433result in mongo
  #there are no today's 4433result in mongo, then count it and save it to mongodb
  
  
  profitdata <-get_countdata(today);
  profitdata$date <-rep(today, times = nrow(profitdata))
  
  
  print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
  print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
  print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
  print("nrow of count 4433data")
  print(nrow(profitdata))
  print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
  print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
  print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
  
  #find the chinese name
  fundprofile <- mongo(collection = "fundprofile" ,db="fund20160414", url = "mongodb://localhost")
  fundprofiledata <- fundprofile$find()
  #find 4433_100 chinese name
  fundprofile_4433_data <-subset(fundprofiledata,fundprofiledata$id %in% profitdata$id)
  profitdata$name <- fundprofile_4433_data[,2]
  
  ######future work modify db 
  #insert 4433result to mongodb=================================
  #mongo_result4433 <- mongo(collection = "result4433" ,db="fund20160414", url = "mongodb://localhost")
  #mongo_result4433$drop()
  #mongo_result4433$insert(profitdata)
  
  
  #################
  ################
  ###############

  
  #======================count 4433_100 and insert db=========================
  #4433前100名 data
  result4433_100<-subset(profitdata,profitdata$rank_1y <= 100 & profitdata$rank_2y <= 100 & profitdata$rank_3y <= 100 & profitdata$rank_5y <= 100 & profitdata$rank_3m <= 100 & profitdata$rank_6m <= 100)
  
  #give it today's date
  result4433_100$date <-rep(today, times = nrow(result4433_100))
  #find the chinese name
  fundprofile <- mongo(collection = "fundprofile" ,db="fund20160414", url = "mongodb://localhost")
  fundprofiledata <- fundprofile$find()
  #find 4433_100 chinese name
  fundprofile_4433_100_data <-subset(fundprofiledata,fundprofiledata$id %in% result4433_100$id)
  result4433_100$name <- fundprofile_4433_100_data[,2]
  
  #insert 4433_100result to mongodb
  mongo_result4433_100 <- mongo(collection = "result4433_100" ,db="fund20160414", url = "mongodb://localhost")
  mongo_result4433_100$drop()
  mongo_result4433_100$insert(result4433_100)
  
  
  #======================count 4433 and insert db======================
  #4433data
  result4433<-subset(profitdata,profitdata$rank_1y <= nrow(profitdata)/4 & profitdata$rank_2y <= nrow(profitdata)/4 & profitdata$rank_3y <= nrow(profitdata)/4 & profitdata$rank_5y <= nrow(profitdata)/4 & profitdata$rank_3m <= nrow(profitdata)/3 & profitdata$rank_6m <= nrow(profitdata)/3)
  
  #give it today's date
  result4433$date <-rep(today, times = nrow(result4433))
  
  #give it type
  result4433$type <-rep("4433", times = nrow(result4433))
  
  #find 4433 chinese name
  fundprofile_4433_data <-subset(fundprofiledata,fundprofiledata$id %in% result4433$id)
  result4433$name <- fundprofile_4433_data[,2]
  
  #insert 4433result to mongodb=================================
  mongo_result4433 <- mongo(collection = "result4433" ,db="fund20160414", url = "mongodb://140.119.19.21")
  mongo_result4433$drop()
  mongo_result4433$insert(result4433)
  
  #======================count 4433_100 and insert db=========================
  #4433前50名 data
  result4433_50<-subset(profitdata,profitdata$rank_1y <= 50 & profitdata$rank_2y <= 50 & profitdata$rank_3y <= 50 & profitdata$rank_5y <= 50 & profitdata$rank_3m <= 50 & profitdata$rank_6m <= 50)
  
  #give it today's date
  result4433_50$date <-rep(today, times = nrow(result4433_50))
  #find the chinese name
  fundprofile <- mongo(collection = "fundprofile" ,db="fund20160414", url = "mongodb://localhost")
  fundprofiledata <- fundprofile$find()
  #find 4433_100 chinese name
  fundprofile_4433_50_data <-subset(fundprofiledata,fundprofiledata$id %in% result4433_50$id)
  result4433_50$name <- fundprofile_4433_50_data[,2]
  
  #insert 4433_100result to mongodb
  mongo_result4433_50 <- mongo(collection = "result4433_50" ,db="fund20160414", url = "mongodb://localhost")
  mongo_result4433_50$drop()
  mongo_result4433_50$insert(result4433_50)
  
  

  
  if(type=="4433_100"){
    return(result4433_100);
    
  }else if (type=="4433"){
    return(result4433);
  }else if(type=="4433_50"){
    return(result4433_50)
  }
}

#get counted data with ranking
get_countdata <-function(today){
  #=========================================================================================
  profitdata <- data.frame(id = character(0), profit_3m= numeric(0), profit_6m= numeric(0), profit_1y= numeric(0), profit_2y= numeric(0), profit_3y= numeric(0), profit_5y= numeric(0),stringsAsFactors=FALSE)
  
  co = "fundprofile"
  con <- mongo(collection = co ,db="fund20160414", url = "mongodb://localhost")
  
  data <- con$find()
  rm(con)
  gc()
  
  #get data for 5 years
  start <- seq(today, length = 2, by = "-5 years")[2]
  end <- today
  
  
  for (i in 1:nrow(data)){
    fundname = data[,1][i]
    fundcollection <- mongo(collection = fundname ,db="fund20160414", url = "mongodb://localhost/?sockettimeoutms=1200000")
    
    #find the fund which are over five years
    if(fundcollection$count()>0){
      
      checkdate <-fundcollection$find(limit = 1)
      if(checkdate[,1][1]<=start){
        
        x <-fundcollection$find()
        if(x[,1][1]<=start & x[,1][length(x[,1])] >=end){
          
          subdata<-subset(x,x[,1] > start & x[,1] < end)
          #計算4433所需要的績效值
          cal <-calculator4433(subdata,today)
          profitdata[nrow(profitdata)+1,]<-c(data[,1][i],cal)
          
        }else{
          #print("no")
        }
      }
    }
    rm(fundcollection)
    gc()
  }
  #rank 4433
  profitdata$rank_3m[order(as.numeric(profitdata$profit_3m),decreasing = TRUE)] <- 1:nrow(profitdata)
  profitdata$rank_6m[order(as.numeric(profitdata$profit_6m),decreasing = TRUE)] <- 1:nrow(profitdata)
  profitdata$rank_1y[order(as.numeric(profitdata$profit_1y),decreasing = TRUE)] <- 1:nrow(profitdata)
  profitdata$rank_2y[order(as.numeric(profitdata$profit_2y),decreasing = TRUE)] <- 1:nrow(profitdata)
  profitdata$rank_3y[order(as.numeric(profitdata$profit_3y),decreasing = TRUE)] <- 1:nrow(profitdata)
  profitdata$rank_5y[order(as.numeric(profitdata$profit_5y),decreasing = TRUE)] <- 1:nrow(profitdata)
  return(profitdata)
}

#計算4433
calculator4433 <- function(data,today){
  
  start_5y <- seq(today, length = 2, by = "-5 years")[2]
  start_1y <- seq(today, length = 2, by = "-1 years")[2]
  start_2y <- seq(today, length = 2, by = "-2 years")[2]
  start_3y <- seq(today, length = 2, by = "-3 years")[2]
  start_6m <- seq(today, length = 2, by = "-6 months")[2]
  start_3m <- seq(today, length = 2, by = "-3 months")[2]
  
  
  #計算五年獲利％數
  profit_5y <- (as.double(data[length(data[,1]),][2]) - as.double(data[1,][2]))/as.double(data[1,][2])*100
  
  #計算三年獲利％數
  subdata <-subset(data,data[,1] > start_3y)
  profit_3y <- (as.double(subdata[length(subdata[,1]),][2]) - as.double(subdata[1,][2]))/as.double(subdata[1,][2])*100
  
  #計算兩年獲利％數
  subdata <-subset(data,data[,1] > start_2y)
  profit_2y <- (as.double(subdata[length(subdata[,1]),][2]) - as.double(subdata[1,][2]))/as.double(subdata[1,][2])*100
  
  #計算一年獲利％數
  subdata <-subset(data,data[,1] > start_1y)
  profit_1y <- (as.double(subdata[length(subdata[,1]),][2]) - as.double(subdata[1,][2]))/as.double(subdata[1,][2])*100
  
  #計算六個月獲利％數
  subdata <-subset(data,data[,1] > start_6m)
  profit_6m <- (as.double(subdata[length(subdata[,1]),][2]) - as.double(subdata[1,][2]))/as.double(subdata[1,][2])*100
  
  #計算三個月獲利％數
  subdata <-subset(data,data[,1] > start_3m)
  profit_3m <- (as.double(subdata[length(subdata[,1]),][2]) - as.double(subdata[1,][2]))/as.double(subdata[1,][2])*100
  
  return(c(profit_3m,profit_6m,profit_1y,profit_2y,profit_3y,profit_5y))
}
