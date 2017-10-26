library(microbenchmark)

source("./api/api_ranxplorer.R")
source("./api/api_semrush.R")
source("./api/api_yooda.R")


res <-  microbenchmark(
   semrushGetInfoByUrl("ovh.com","fr", 10),
   ranxplorerGetInfoByUrl("www.ovh.com",10),
   yoodaGetInfoByUrl("ovh.com",10),
   times = 10
 )

print("---------test 10 ----------")
print(res)

res <-  microbenchmark(
  semrushGetInfoByUrl("ovh.com","fr", 100),
  ranxplorerGetInfoByUrl("www.ovh.com",100),
  yoodaGetInfoByUrl("ovh.com",100),
  times = 10
)

print("---------test 100 ----------")
print(res)


res <-  microbenchmark(
  semrushGetInfoByUrl("ovh.com","fr", 1000),
  ranxplorerGetInfoByUrl("www.ovh.com",1000),
  yoodaGetInfoByUrl("ovh.com",1000),
  times = 10
)

print("---------test 1000 ----------")
print(res)