
# get last days

# https://www.google.com/webmasters/tools/search-analytics?hl=fr&authuser=1&siteUrl=https://www.ovh.com/fr/#state=%5Bnull%2C%5B%5Bnull%2Cnull%2Cnull%2C7%5D%5D%2Cnull%2C%5B%5Bnull%2C6%2C%5B%22WEB%22%5D%5D%5D%2Cnull%2C%5B1%2C2%2C3%2C4%5D%2C1%2C0%2Cnull%2C%5B2%5D%5D

library(googleAuthR)
library(searchConsoleR)
library(dplyr)
library(stringi)
library(stringr)
library(textclean)

gar_auth()

searchconsole <- search_analytics("https://www.ovh.com/fr/", 
                                  # compute on 1 month
                                  #start = "2017-09-21",
                                  #end = "2017-10-21", 
                                  dimensions = c("query"),
                                  searchType="web", 
                                  rowLimit = 100000,
                                  walk_data = "byBatch")

searchconsole <- select(searchconsole,-clicks,-ctr) %>%
                  arrange(-impressions,position)

colnames(searchconsole) <- c("Kw","Vol","Rx")
searchconsole$Rx <- round(searchconsole$Rx)

searchconsole$Kw <- str_replace_all(searchconsole$Kw, "([><=+$*^~])|[[:punct:]]", " ")

searchconsole_unique <- select(searchconsole,Kw,Vol,Rx) %>%
  arrange(-Vol,Rx) %>%
  filter(!duplicated(Kw)
         # remove urls
         & !stri_detect_fixed("http",Kw,case_insensitive=TRUE)
  ) 



# searchconsole_unique <- head(searchconsole_unique,10000) 

DFsearchconsole <- data.frame(as.character(searchconsole_unique$Kw))
colnames(DFsearchconsole) <- c("Kw")
rownames(DFsearchconsole) <- DFsearchconsole$Kw  
