library(mongolite)
library(RJSONIO)

library(rmongodb)




#set db config
db="fund20160414"
url = "mongodb://140.119.19.21"

#saveportfolio <- function(portfolio){
  
  #get data from front-end
  #portfolio <- fromJSON(portfolio)
  
  
  #portfolio$portfolio <- rep(paste0(portfolio$user,gsub(":","",gsub(" ", "", as.character(Sys.time())))),nrow(portfolio))
  #insert portfolio to mongodb=================================
  
  
  portfoliokey = "admin1470281038329"
  
  portfoliodb <- mongo(collection = "portfolio" ,db=db, url = url)
  
  portfoliodb$remove((paste0('{"portfoliokey" : {"$eq" :"' ,portfoliokey , '"}}')))
  #toJSON("deleted")
#}