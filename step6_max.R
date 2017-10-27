library(microbenchmark)

source("./api/api_ranxplorer.R")
source("./api/api_semrush.R")
source("./api/api_yooda.R")


maxSemrush <- semrushGetInfoByUrl("ovh.com","fr", 50000)

maxRanxplorer <- ranxplorerGetInfoByUrl("ovh.com",50000)

maxYooda <- yoodaGetInfoByUrl("ovh.com",50000)

