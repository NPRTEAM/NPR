# do jsonlite i curl wymagana instalacja libcurl4-openssl-dev w menedzerze pakietow

library(jsonlite)
library(curl)
library(plotly)

latestLink = "http://api.nbp.pl/api/exchangerates/tables/a/?format=json"
timeRangeLink = 'http://api.nbp.pl/api/exchangerates/rates/a/%s/%s/%s/?format=json'
jsonFilePath = paste0(getSrcDirectory(function(x) {x}), "/latest-currencies.json", "")

getDatabaseDate <- function() {
  database <- fromJSON(jsonFilePath)
  return (database$effectiveDate)
}

getNames <- function() {
  database <- fromJSON(jsonFilePath)
  return (database$rates[[1]][1])
}

getCodes <- function() {
  database <- fromJSON(jsonFilePath)
  return (database$rates[[1]][2])
}

getValues <- function() {
  database <- fromJSON(jsonFilePath)
  return (database$rates[[1]][3])
}

getValueByCode <- function(code) {
  database <- fromJSON(jsonFilePath)
  indexOfCode = which(database$rates[[1]][2] == code)
  return (database$rates[[1]][indexOfCode,3])
}

getValueByName <- function(name) {
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
  database <- fromJSON(sprintf(timeRangeLink, code, dateFrom, dateTo))
  return (database$rates$mid)
}

getValuesFromRangeByName <- function(name, dateFrom, dateTo) {
  database <- fromJSON(jsonFilePath)
  indexOfName = which(database$rates[[1]][1] == name)
  codeFromIndex = database$rates[[1]][indexOfName,2]
  database <- fromJSON(sprintf(timeRangeLink, codeFromIndex, dateFrom, dateTo))
  return (database$rates$mid)
}