library(RJSONIO)

uniqueSort <- function(test){
  test <- fromJSON(test)
  test <- unlist(test$test)
  test <- unique(test)
  test <- sort(test)
  res <- list(test=test)
  toJSON(res)
}