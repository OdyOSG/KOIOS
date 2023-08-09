library(KOIOS)

##### INPUT #####

#Load concept library
concepts <- loadConcepts()

#Input VCF
vcf <- loadVCF(userVCF = "Test VCF/GSE142442_RAW/GSE142442_129_MWS.vcf")

#Please enter one of hg18, hg19, hg38 or "auto"
ref <- "auto"

#Please indicate whether or not you would like to return all transcript alleles
generateTranscripts <- "TRUE"

##### MAIN #####

#Automatic mode - sampling and testing
if(ref == "auto"){
  ref <- findReference(vcf)
}

ref.df <- loadReference(ref)

vcf.df <- processVCF(vcf)

vcf.df <- generateHGVSG(vcf = vcf.df, ref = ref.df)

alleles.df <- processClinGen(vcf.df,ref,generateAll = generateTranscripts)

concepts.df <- addConcepts(alleles.df, concepts)






vcf.df <- processVCF(vcf)

vcf.snv <- vcf.df[stringr::str_length(vcf.df$REF) == 1 & stringr::str_length(vcf.df$ALT) == 1,]

if(dim(vcf.snv)[1] < 10){
  message("Less than 10 SNVs detected.")
  vcf.snv <- vcf.df
}

#Sample 100 rows
if(dim(vcf.snv)[1] > 15){
  vcf.snv <- vcf.snv[sample(x = dim(vcf.snv)[1], size = 15, replace = F),]
}

ref.hg18 <- loadReference("hg18")
ref.hg19 <- loadReference("hg19")
ref.hg38 <- loadReference("hg38")

vcf.hg18 <- generateHGVSG(vcf.df = vcf.snv, ref.df = ref.hg18)
vcf.hg19 <- generateHGVSG(vcf.df = vcf.snv, ref.df = ref.hg19)
vcf.hg38 <- generateHGVSG(vcf.df = vcf.snv, ref.df = ref.hg38)

alleles.hg18 <- processClinGen(vcf.df = vcf.hg18, ref = "hg18", generateAll = F)
alleles.hg19 <- processClinGen(vcf.df = vcf.hg19, ref = "hg19", generateAll = F)
alleles.hg38 <- processClinGen(vcf.df = vcf.hg38, ref = "hg38", generateAll = F)

alleles.hg18 <- alleles.hg18[!is.na(alleles.hg18$hgvsg),]
alleles.hg19 <- alleles.hg19[!is.na(alleles.hg19$hgvsg),]
alleles.hg38 <- alleles.hg38[!is.na(alleles.hg38$hgvsg),]

#Find reference genome
resultLength <- c(dim(alleles.hg18)[1],dim(alleles.hg19)[1],dim(alleles.hg38)[1])

#Set reference genome
ref <- c("hg18","hg19","hg38")[which.max(resultLength)]
