
#This code verify and infer the ancestral genotype in the vcf file
#requires the reference and two outgroups close the the specie in a same vcf file


#output= the chromosome, position, the reference allele, the alternative allele, 
#the ancestral state (ancestral state inferred if different from the reference), 
#the genotype of the two ancestral individual 

setwd("path")

inputAnc="myfile.vcf"

Anc  <- file(inputAnc, open = "r")
outputFileAnc<- "my.Outgroup_Ances_est.txt"

i=1
j=1


while (length(oneLine <- readLines(Anc, n = 1, warn = FALSE)) > 0) {
  if (length(grep("#",oneLine))==0) {
#    print(oneLine)
	oneLineR<-unlist(strsplit(oneLine, split="\t"))

#	print(substr(oneLineR[11],1,3))
#genotype should be identifical between individuals and not heterozygotes = ambiguity
	
if(substr(oneLineR[11],1,3)!="./."|substr(oneLineR[10],1,3)!="./."){		
		if (substr(oneLineR[11],1,3)=="./.") {sum<-(abs(as.numeric(substr(oneLineR[10],1,1))-as.numeric(substr(oneLineR[10],3,3)))) 
			} else {
				if (substr(oneLineR[10],1,3)=="./.") {sum<-(abs(as.numeric(substr(oneLineR[11],1,1))-as.numeric(substr(oneLineR[11],3,3))))
					} else {
					if (substr(oneLineR[10],1,3)==substr(oneLineR[11],1,3)) {sum<-abs(as.numeric(substr(oneLineR[10],1,1))-as.numeric(substr(oneLineR[10],3,3)))} else {sum<-1
						}
					}
			}

#	print(sum)
	if(sum==0) {	
		j<-j+1
		if ( (substr(oneLineR[11],1,3)=="1/1") || (substr(oneLineR[10],1,3)=="1/1") ) {ancestralstate<-oneLineR[5]} else {
																ancestralstate<-oneLineR[4]
																}
		text<-t(c(oneLineR[1],oneLineR[2],oneLineR[4],oneLineR[5],substr(oneLineR[10],1,3), substr(oneLineR[11],1,3),ancestralstate[1]))
		colnames(text)=c("")
		write.table(text, file = outputFileAnc, sep = " ", quote=FALSE, col.names=FALSE, row.names=FALSE, append=TRUE)		

		}
				
   	print(i)
	print(j)	
	i<-i+1
}	
  }
}
close(Anc) 
