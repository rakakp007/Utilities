library(data.table)
library(stringr)

############################################################
# Script name: ped2hapmap.R
#
# Description:
# This script converts PLINK PED/MAP genotype files into
# HapMap (.hmp.txt) format compatible with Gapit.
#
# Author: Rakakpo - IFREMER - La Tremblade - FR @@@@
# Date: 12/12/22025
############################################################


setwd("....................")

# -------- INPUT FILES --------
ped_file <- "geno_NTA_Aestru.ped"
map_file <- "geno_NTA_Aestru.map"
out_file <- "geno_NTA_Aestru.hmp"

# -------- READ FILES --------
map <- fread(map_file, header = FALSE)
colnames(map) <- c("chrom", "snp", "cm", "pos")

ped <- fread(ped_file, header = FALSE,  colClasses = "character", showProgress = FALSE)

# -------- SAMPLE NAMES --------
sample_ids <- ped$V2

# -------- GENOTYPES --------
geno <- ped[, -(1:6), with = FALSE]
for (j in seq_along(geno)) {
  set(geno, i = which(geno[[j]] %in% c("0", "-9")), j = j, value = "N")
}

# Number of SNPs
n_snps <- ncol(geno) / 2
n_samples <- nrow(geno)

# Initialize matrix: SNPs x Samples
geno_hmp <- matrix(NA, nrow = n_snps, ncol = n_samples)

for (i in 1:n_snps) {
  a1 <- geno[[2*i - 1]]
  a2 <- geno[[2*i]]
  # Combine, but if either is N, result should be NN
  geno_hmp[i, ] <- ifelse(a1 == "N" | a2 == "N", "NN", paste0(a1, a2))
}

rownames(geno_hmp) <- map$snp
colnames(geno_hmp) <- sample_ids


# Assign names
rownames(geno_hmp) <- map$snp
colnames(geno_hmp) <- sample_ids


# -------- ALLELES COLUMN --------

alleles <- apply(geno_hmp, 1, function(x) {
  # Keep only non-missing genotypes
  non_missing <- x[x != "NN"]
  # Split alleles into single letters
  a <- unique(unlist(strsplit(non_missing, "")))
  # Sort alleles alphabetically and collapse into a string (no slash)
  paste(sort(a), collapse = "/")
})

# -------- BUILD HAPMAP --------
hapmap <- data.table(
  rs = map$snp,
  alleles = alleles,
  chrom = map$chrom,
  pos = map$pos,
  strand = "+",
  assembly = "NA",
  center = "NA",
  protLSID = "NA",
  assayLSID = "NA",
  panelLSID = "NA",
  QCcode = "NA"
)

hapmap <- cbind(hapmap, geno_hmp)

# -------- WRITE FILE --------
fwrite(hapmap, out_file, sep = "\t", quote = FALSE)


