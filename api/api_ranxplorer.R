library(dplyr)
library(RCurl)
library(rjson)
library(urltools)
library(stringr)

source("./api/conf.R")

#curl -G "http://api.ranxplorer.com/v1/seo/keywords" \
#-H "Accept: application/json" \
#-H "X-Ranxplorer-Token: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
#-d "search"="www.ranks.fr" \
#-d "limit"="2" \

ranxplorerGetInfoByUrl <- function(site,nb) {
  
  url <- paste("http://api.ranxplorer.com/v1/seo/keywords?search=",site,"&limit=",nb,sep="")
  
  print(url)

  filename <- tempfile()
  
  f <- CFILE(filename, "wb")
  curlPerform(url = url
              , httpheader=c(Accept="application/json"
                              ,"X-Ranxplorer-Token"=keyAPIranxplorer)
              , writedata = f@ref
              , encoding = "UTF-8"
              #, verbose = TRUE
  )
  close(f)
  

  json <- fromJSON(file=filename)
  
  if (json$errors==FALSE) {
    
    DF <- do.call(rbind.data.frame, c(json$data, stringsAsFactors=FALSE))
    
    DF <- select(DF,-Est)
    
    DF$Date <- as.Date(DF$Date, format = "%Y-%m-%d")
    
    return(DF)
  }
  else {
    return("error")
  }

}

#ranxplorer <- ranxplorerGetInfoByUrl("www.ovh.com",1)

