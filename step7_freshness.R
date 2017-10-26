
source("./api/api_ranxplorer.R")
source("./api/api_semrush.R")
source("./api/api_yooda.R")

semrush <- semrushGetInfoByUrl("ovh.com","fr", 50000)
freshness_semrush <- mean(semrush$Date)
freshness_semrush <- as.Date(as.POSIXct(freshness_semrush, origin="1970-01-01"))

ranxplorer <- ranxplorerGetInfoByUrl("www.ovh.com",50000)
freshness_ranxplorer <- mean(ranxplorer$Date)

yooda <- yoodaGetInfoByUrl("ovh.com",50000)
freshness_yooda <- mean(yooda$Date)

