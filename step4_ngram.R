library(text2vec)
library(glmnet)
library(ggplot2)
library(tm)

# step 3 : filter your keyword and cluster


lang <- "fr"

# retirer les accents
# retirer les mots creux

Unaccent <- function(text) {
  text <- gsub("['`^~\"]", " ", text)
  text <- iconv(text, to="ASCII//TRANSLIT//IGNORE")
  text <- gsub("['`^~\"]", "", text)
  return(text)
}


getNgram <- function(DF_PotentialKeywords) {
  
  # personalize your stopwords
  stopwords <- stopwords(kind = lang)
  
  DF_PotentialKeywords <- mutate(DF_PotentialKeywords,Kw=Unaccent(Kw)) 

  
  DF_PotentialKeywordsTemp <- DF_PotentialKeywords
  
  for (i in 1:length(stopwords)) {
    
    DF_PotentialKeywords_stopwords <- as.data.frame(sapply(DF_PotentialKeywordsTemp
                                                           ,gsub,pattern=paste(" ",stopwords[i]," ",sep="")
                                                           ,replacement=" "))  
    
    DF_PotentialKeywordsTemp <- DF_PotentialKeywords_stopwords
  }
  
  DF_PotentialKeywords <- data.frame(lapply(DF_PotentialKeywordsTemp, as.character), stringsAsFactors=FALSE)  
  
  it <- itoken(DF_PotentialKeywords[['Kw']], preprocess_function = tolower, 
               tokenizer = word_tokenizer, chunks_number = 6, progessbar = F)
  
  # keep only 2 and 3 grams
  vocab <- create_vocabulary(it, ngram = c(2L, 4L))
  
  DF_SEO_vocab <- data.frame(vocab$vocab) 
  
  # keep only top 50
  DF_SEO_vocab <- arrange(DF_SEO_vocab,-terms_counts) %>% 
                    top_n(20)
  
  
}

DF_Keywords_semrush <- filter(DF_withSC,semrush==1 & searchconsole==0 & ranxplorer==0)
DF_semrush_unique <- getNgram(DF_Keywords_semrush)

DF_Keywords_ranxplorer <- filter(DF_withSC,semrush==0 & searchconsole==0 & ranxplorer==1)
DF_ranxplorer_unique <- getNgram(DF_Keywords_ranxplorer)

DF_Keywords_searchconsole <- filter(DF_withSC,searchconsole==1 & ranxplorer==0 & semrush==0)
DF_searchconsole_unique <- getNgram(DF_Keywords_searchconsole)


