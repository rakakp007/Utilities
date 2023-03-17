# Charger le fichier definissant l'etat ancestral
Ancestral=read.table("Outgroup_Ancestral.txt",colClasses="character")
names(Ancestral)=c("Chr","Position","REF","ALT","Outgroup1","Outgroup2","Ancestral")
Ancestral$UniqueID=paste(Ancestral$Chr,"_",Ancestral$Position,sep="")

# Lire le vcf ligne a ligne
input <- "Calling_Transcriptome_GATK_Allc03d_Simple.vcf"
output <- "Calling_Calling_Transcriptome_GATK_Allc03d_Polarized.vcf"
#### Open the connection and determine the length (in row) of the header ####
print("open the connection")
con_in <- file(input, open='r')
i <- 1
test <- readLines(con_in,n=1)
while(grepl(pattern="#", test)==TRUE){
  test <- readLines(con_in,n=1)
  i <- i+1
} 
close(con_in)

#### Open a new connection to read only the last line of the header ####
con_in <- file(input, open='r')
i <- i-1
header <- readLines(con_in,n=i)
close(con_in)
head <- unlist(strsplit(header[length(header)], split="\t"))

#### Open a new connection to read only the last line of the header ####
con_in <- file(input, open='r')
readLines(con_in,n=i)

#### Saving the resulting dataframe in a new vcf-like file ####
print("saving")
con_out <- file(output, open="w")
writeLines(text = header,con = con_out)
close(con_out)

j <- 0
rejected_snp <- NULL
##### now we read the file line by line and extract SNPs that can be polarized ####
while (length(oneLine <- readLines(con_in, n = 1, warn = FALSE)) > 0) {
  ###### Increment the counter and print it ######
  j = j + 1
  print(paste("Reading line ",j,sep=""))
  
  ###### splitting the raw data ######
  oneLine<- unlist(strsplit(oneLine, split="\t"))
  names(oneLine) <- head
      ID <- paste(oneLine["#CHROM"],oneLine["POS"],sep="_")
      if(isTRUE(oneLine[["REF"]] ==  Ancestral[Ancestral$UniqueID==ID,]$Ancestral)){
        write.table(t(oneLine),output,append=TRUE,quote=FALSE,col.names=FALSE,row.names=FALSE,sep="\t")
      } else  if(isTRUE(oneLine[["ALT"]] ==  Ancestral[Ancestral$UniqueID==ID,]$Ancestral)){
        oneLine[oneLine == "0/0"] <- "2/2"
        oneLine[oneLine == "1/1"] <- "0/0"
        oneLine[oneLine == "2/2"] <- "1/1"
        REF_tmp <- oneLine["ALT"]
        oneLine["ALT"] <- oneLine["REF"]
        oneLine["REF"] <- REF_tmp
        write.table(t(oneLine),output,append=TRUE,quote=FALSE,col.names=FALSE,row.names=FALSE,sep="\t")
      } else {print("rejected snp")
              rejected_snp <- c(rejected_snp,ID) }
}
write.table(rejected_snp,"Rejected_SNP.txt")

close(con_in)

q()



