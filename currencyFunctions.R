# wymagana instalacja libcurl4-openssl-dev w menedzerze pakietow

library(jsonlite)
library(curl)

baseLink = "http://api.nbp.pl/api/exchangerates/tables/a/?format=json"
filePath = paste0(getSrcDirectory(function(x) {x}), "/latest-currencies.js", "")

getDatabaseDate <- function() {
  database <- fromJSON(filePath)
  return (database$effectiveDate)
}

getNames <- function() {
  database <- fromJSON(filePath)
  return (database$rates[[1]][1])
}

getCodes <- function() {
  database <- fromJSON(filePath)
  return (database$rates[[1]][2])
}

getValues <- function() {
  database <- fromJSON(filePath)
  return (database$rates[[1]][3])
}

getValueByCode <- function(code) {
  database <- fromJSON(filePath)
  indexOfCode = which(database$rates[[1]][2] == code)
  return (database$rates[[1]][indexOfCode,3])
}

getValueByName <- function(name) {
  database <- fromJSON(filePath)
  indexOfName = which(database$rates[[1]][1] == name)
  return (database$rates[[1]][indexOfName,3])
}

updateDatabase <- function() {
  updatedTable <- fromJSON(baseLink)
  write_json(updatedTable,filePath)
}