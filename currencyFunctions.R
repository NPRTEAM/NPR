# do jsonlite i curl wymagana instalacja libcurl4-openssl-dev w menedzerze pakietow

library(jsonlite)
library(curl)
library(plotly)

latestLink = "http://api.nbp.pl/api/exchangerates/tables/a/?format=json"
timeRangeLink = 'http://api.nbp.pl/api/exchangerates/rates/a/%s/%s/%s/?format=json'
jsonFilePath = "latest-currencies.json"

checkIfJsonExists <- function() {
  if (!file.exists(jsonFilePath)) {
    updateDatabase()
  }
}

#calculateCurrency <- function(baseCurrency,targetCurrency){
# return (getValueByName(baseCurrency) / getValueByName(targetCurrency))
#}


getDatabaseDate <- function() {
  checkIfJsonExists()
  database <- fromJSON(jsonFilePath)
  return (database$effectiveDate)
}

getNames <- function() {
  checkIfJsonExists()
  database <- fromJSON(jsonFilePath)
  return (database$rates[[1]][1])
}

getCodes <- function() {
  checkIfJsonExists()
  database <- fromJSON(jsonFilePath)
  return (database$rates[[1]][2])
}

getValues <- function() {
  checkIfJsonExists()
  database <- fromJSON(jsonFilePath)
  return (database$rates[[1]][3])
}

getValueByCode <- function(code) {
  checkIfJsonExists()
  database <- fromJSON(jsonFilePath)
  indexOfCode = which(database$rates[[1]][2] == code)
  return (database$rates[[1]][indexOfCode,3])
}

getValueByName <- function(name) {
  checkIfJsonExists()
  database <- fromJSON(jsonFilePath)
  indexOfName = which(database$rates[[1]][1] == name)
  return (database$rates[[1]][indexOfName,3])
}

updateDatabase <- function() {
  updatedTable <- fromJSON(latestLink)
  updatedTable$rates[[1]][nrow(updatedTable$rates[[1]])+1,] <- list(currency="polski złoty", code="PLN", mid=1.0)
  write_json(updatedTable,jsonFilePath)
}

getValuesFromRangeByCode <- function(code, dateFrom, dateTo) {
  checkIfJsonExists()
  database <- fromJSON(sprintf(timeRangeLink, code, dateFrom, dateTo))
  return (database$rates$mid)
}

getValuesFromRangeByName <- function(name, dateFrom, dateTo) {
  checkIfJsonExists()
  database <- fromJSON(jsonFilePath)
  indexOfName = which(database$rates[[1]][1] == name)
  codeFromIndex = database$rates[[1]][indexOfName,2]
  database <- fromJSON(sprintf(timeRangeLink, codeFromIndex, dateFrom, dateTo))
  return (database$rates$mid)
}

getPlotDataframe <- function(names, dateFrom, dateTo) {
  checkIfJsonExists()
  localDatabase <- fromJSON(jsonFilePath)
  frame <- data.frame()
  for(name in names) {
    indexOfName = which(localDatabase$rates[[1]][1] == name)
    codeFromIndex = localDatabase$rates[[1]][indexOfName,2]
    remoteDatabase <- fromJSON(sprintf(timeRangeLink, codeFromIndex, dateFrom, dateTo))
    currName <- name
    values <- remoteDatabase$rates$mid
    dates <- as.Date(remoteDatabase$rates$effectiveDate)
    frame <- rbind(frame,data.frame(Waluta=currName, Wartość=values, Data=dates))
  }
  return (frame)
}
