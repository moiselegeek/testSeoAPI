library(dplyr)
library(RCurl)
library(rjson)
library(urltools)
library(stringr)

source("./api/conf.R")

### API YOODA
yoodaURLAPI <- "https://api-v2.yooda.com" 
yoodaLIMIT <- 5000

# curl -X "GET" -H "Accept:\ application/json" -H "Content-type:\ application/x-www-form-urlencoded" https://api-v2.yooda.com/insight/domains/ovh.com?apikey=9ee5033a8a67a7bf53e236f767eeb4
yoodaCallDomains <- function(domain) {
  url <- paste(yoodaURLAPI,"/insight/domains/",domain,"?apikey=",keyAPIyooda,sep="")
  
  #print(url)
  
  filename <- tempfile()
  
  f <- CFILE(filename, "wb")
  curlPerform(url = url
              , httpheader=c(Accept="application/json",
                             "Content-type"="application/json")
              , writedata = f@ref
              , encoding = "UTF-8"
              , verbose = TRUE
  )
  close(f)
  
  #print(filename)
  
  json <- fromJSON(file=filename)
  
  if (json$status=="success") {
    return(json$content$id) 
  }  else {
    return(json$content$message)
  }
}




#  GET https://api-v2.yooda.com/insight/domains/2105026/keywords?return_max=5000&return_initial_position=0
yoodaCallKeywords <- function(domain_id, limit, init) {
  
  url <- paste(yoodaURLAPI,"/insight/domains/",domain_id,"/keywords?return_max=",limit,"&return_initial_position=",init,"&apikey=",keyAPIyooda,sep="")
  
  #print(url)
  
  filename <- tempfile()
  
  f <- CFILE(filename, "wb")
  curlPerform(url = url
              , httpheader=c(Accept="application/json",
                             "Content-type"="application/json")
              , writedata = f@ref
              , encoding = "UTF-8"
              #, verbose = TRUE
  )
  close(f)
  
  #print(filename)
  
  json <- fromJSON(file=filename)
  
  return(json)
}

yoodaGetInfoByUrl <- function(domain, max) {
  
  domain_id <- yoodaCallDomains(domain)

  if (max < yoodaLIMIT )
    json <- yoodaCallKeywords(domain_id, max, 0)
  else
    json <- yoodaCallKeywords(domain_id, yoodaLIMIT, 0)
  
  if (json$status=="success") {
    
    nbresult <- as.integer(json$content$items_count)

    if ( max <= yoodaLIMIT )
      iter <- 0 
    else if ( max >= nbresult )
      iter <- round(nbresult/yoodaLIMIT)
    else {
      iter <- floor(max/yoodaLIMIT)
    }
    
    listRes <-lapply(json$content$items_list,function(xl) xl$keyword) 
    DF <- do.call(rbind.data.frame, listRes)
    
    if (iter>0) {
      for (i in 1:iter) {
        
        if(max<nbresult & i==iter) 
          yoodaLIMITMAX <- max - yoodaLIMIT*iter
        else
          yoodaLIMITMAX <- yoodaLIMIT
        
        json <- yoodaCallKeywords(domain_id, yoodaLIMITMAX, yoodaLIMIT*i)
        listRes <-lapply(json$content$items_list,function(xl) xl$keyword) 
        DF <- rbind(DF,do.call(rbind.data.frame, c(listRes, stringsAsFactors=FALSE)))
      }
    }
    
    DF <- select(DF, keyword, search_volume, results_nb, cpc, date)
    
    DF$date <- as.Date(DF$date, format = "%Y-%m-%d")
    
    # "Url","Rx",
    colnames(DF) <- c("Kw","Vol","Nb","Cpc","Date")

    return(DF)
    
  }
  else {
    return(json$content$message)
  }
  
}

#yooda <- yoodaGetInfoByUrl("ovh.com",1)


