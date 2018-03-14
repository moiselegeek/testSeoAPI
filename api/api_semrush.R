library(dplyr)
library(RCurl)
library(rjson)
library(urltools)
library(stringr)

source("./api/conf.R")

### API SEMRUSH


# be careful with duplicate

semrushGetInfoByUrl <- function(url,country, nb) {
  
  url <- paste("http://api.semrush.com/?type=domain_organic&key=",keyAPIsemrush,"&display_limit=",nb,"&export_columns=Ph,Ur,Po,Nq,Nr,Tc,Ts&domain=",url,"&database=",country, sep="")
  
  #print(url)
  
  filename <- tempfile()
  
  f <- CFILE(filename, "wb")
  curlPerform(url = url
              , writedata = f@ref
              , encoding = "ISO-8859-1"
              #, verbose = TRUE
  )
  close(f)
  
  result <- read.csv2( filename, header = TRUE
                       , sep=";"
                       , encoding = "UTF-8"
                       , stringsAsFactors = FALSE) 
  
  colnames(result) <- c("Kw","Url","Rx","Vol","Nb","Cpc","Date")
  
  # filter somme errors
  result$Rx <- as.integer(result$Rx)
  result$Vol <- as.integer(result$Vol)
  result$Cpc <- as.double(result$Cpc)
  
  result <- filter(result, nchar(Date)>5)
  result$Date <- as.integer(result$Date)
  #result$Date <- as.Date(as.POSIXct(result$Date, origin="1970-01-01"))
  
  return(result)
}

#semrush <- semrushGetInfoByUrl("ovh.com","fr", 2)

