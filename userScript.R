library(KOIOS)

##### INPUT #####

#Load concept library
concepts <- loadConcepts()

#Input VCF
vcf <- loadVCF(userVCF = "Test VCF/GSE142442_RAW/GSE142442_27_AST.vcf")
#vcf <- loadVCF(userVCF = "Test VCF/GSE158506_RAW/GSM4801810_2.somatic_variants_L75P1.vcf")

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

