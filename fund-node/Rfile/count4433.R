require(mongolite)

co =  "fundprofile"
con <- mongo(collection = co, db = "fund20160414", url = "mongodb://140.119.19.21/?sockettimeoutms=1200000")
data <- con$find()
for(i in 1:nrow(data)){
  fundname = data[,1]
  fundcon <- mongo(collection = fundname, db = "fund20160414", url = "mongodb://140.119.19.21/?sockettimeoutms=1200000")
  if(fundcon$count()!=0){
    x <- fundcon.find()
  }
  
}
