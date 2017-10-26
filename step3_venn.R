library(eVenn)

###########################################

DFranxplorer <- data.frame(as.character(ranxplorer_unique$Kw))
colnames(DFranxplorer) <- c("Kw")
rownames(DFranxplorer) <- DFranxplorer$Kw

DFsemrush <- data.frame(as.character(semrush_unique$Kw))
colnames(DFsemrush) <- c("Kw")
rownames(DFsemrush) <- DFsemrush$Kw

DFyooda <- data.frame(as.character(yooda_unique$Kw))
colnames(DFyooda) <- c("Kw")
rownames(DFyooda) <- DFyooda$Kw



#########################################

evenn(matLists=list(ranxplorer=DFranxplorer,semrush=DFsemrush, yooda=DFyooda ), annot=TRUE, display=TRUE, CompName="Comparatif")

fichierVenn <- paste("./Venn.diagrams/venn_Comparatif/VennMatrixBin.txt",sep="")
DF_withoutSC <- read.csv(fichierVenn, sep = "\t", encoding="CP1252", stringsAsFactors=FALSE)
colnames(DF_withoutSC)[1] <- "Kw"
DF_withoutSC <- arrange(DF_withoutSC, Total_lists)

########################################


evenn(matLists=list(ranxplorer=DFranxplorer,semrush=DFsemrush, yooda=DFyooda,searchconsole=DFsearchconsole), annot=TRUE, display=TRUE, CompName="ComparatifwithSC")

fichierVenn <- paste("./Venn.diagrams/venn_ComparatifwithSC/VennMatrixBin.txt",sep="")
DF_withSC <- read.csv(fichierVenn, sep = "\t", encoding="CP1252", stringsAsFactors=FALSE)
colnames(DF_withSC)[1] <- "Kw"
DF_withSC <- arrange(DF_withSC, Total_lists)

evenn(matLists=list(yooda=DFyooda, searchconsole=DFsearchconsole), annot=TRUE, display=TRUE, CompName="Yooda")
evenn(matLists=list(ranxplorer=DFranxplorer, searchconsole=DFsearchconsole), annot=TRUE, display=TRUE, CompName="Ranxplorer")
evenn(matLists=list(semrush=DFsemrush, searchconsole=DFsearchconsole), annot=TRUE, display=TRUE, CompName="Semrush")

