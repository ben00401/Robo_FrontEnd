library(mongolite)
library(RJSONIO)
get_result4433<- function(){
  
  result4433_100 <- mongo(collection = "result4433_100" ,db="fund20160414", url = "mongodb://localhost/?sockettimeoutms=1200000")

  data4433 <- result4433_100$find()
  toJSON(data4433)
}