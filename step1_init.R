
source("./api/api_ranxplorer.R")
source("./api/api_semrush.R")
source("./api/api_yooda.R")


ranxplorer <- ranxplorerGetInfoByUrl("ovh.com",99999)

ranxplorer_unique <- select(ranxplorer,Kw,Vol,Rx) %>%
  arrange(-Vol,Rx) %>%
  filter (!duplicated(Kw))


#########################

semrush <- semrushGetInfoByUrl("ovh.com","fr", 50000)

semrush_unique <- select(semrush,Kw,Vol,Rx) %>%
  arrange(-Vol,Rx) %>%
  filter (!duplicated(Kw))

########################"


yooda <- yoodaGetInfoByUrl("ovh.com",50000)

yooda$Vol  <- as.integer(yooda$Vol) 
yooda_unique <- select(yooda,Kw,Vol) %>%
  arrange(-Vol) %>%
  filter (!duplicated(Kw) )
