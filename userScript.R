library(KOIOS)

##### INPUT #####

#Load concept library
concepts <- loadConcepts()

#Input VCF
vcf <- loadVCF(userVCF = "INPUT VCF")

#Please enter one of hg18, hg19, hg38 or "auto"
ref <- "hg19"

#Please indicate whether or not you would like to return all transcript alleles
generateTranscripts <- "FALSE"



##### MAIN #####

#Automatic mode - sampling and testing
if(ref == "auto"){

  vcf.df <- processVCF(vcf)

  #Sample 100 rows
  if(dim(vcf.df)[1] > 100){
    vcf.df <- vcf.df[sample(x = dim(vcf.df)[1], size = 100, replace = F),]
  }

  ref.hg18 <- loadReference("hg18")
  ref.hg19 <- loadReference("hg19")
  ref.hg38 <- loadReference("hg38")

  vcf.hg18 <- generateHGVSG(vcf = vcf.df, ref = ref.hg18)
  vcf.hg19 <- generateHGVSG(vcf = vcf.df, ref = ref.hg19)
  vcf.hg38 <- generateHGVSG(vcf = vcf.df, ref = ref.hg38)

  alleles.hg18 <- processClinGen(vcf.hg18,"hg18",generateAll = T)
  alleles.hg19 <- processClinGen(vcf.hg19,"hg19",generateAll = T)
  alleles.hg38 <- processClinGen(vcf.hg38,"hg38",generateAll = T)

  #Find reference genome
  resultLength <- c(dim(alleles.hg18)[1],dim(alleles.hg19)[1],dim(alleles.hg38)[1])

  #Set reference genome
  ref <- c("hg18","hg19","hg38")[which.max(resultLength)]

}

ref.df <- loadReference(ref)

vcf.df <- processVCF(vcf)

vcf.df <- generateHGVSG(vcf = vcf.df, ref = ref.df)

alleles.df <- processClinGen(vcf.df,ref,generateAll = generateTranscripts)

concepts.df <- addConcepts(alleles.df, concepts)

