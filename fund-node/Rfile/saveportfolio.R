library(mongolite)
library(RJSONIO)

library(rmongodb)
 



#set db config
#db="fund20160414"
#url = "mongodb://localhost"

saveportfolio <- function(portfolio){
  print("in saveportfoli.R")
  print(portfolio)
  
  
  #get data from front-end
  portfolio <- fromJSON(portfolio)

  
  #portfolio$portfolio <- rep(paste0(portfolio$user,gsub(":","",gsub(" ", "", as.character(Sys.time())))),nrow(portfolio))
  #insert portfolio to mongodb=================================
  mongo <- mongo.create(host="140.119.19.21:27017" ,db="fund20160414")
  mongo.is.connected(mongo)
  
  
  ns <- "fund20160414.portfolio"
  
  
  
  bson <- mongo.bson.from.JSON(portfolio.data)
  mongo.insert(mongo, ns, bson)
  
  
  #m <- mongo(collection = "portfolio" ,db=db, url = url,verbose = TRUE)
  
  #m$insert(portfolio)
  toJSON("inserted")
}


