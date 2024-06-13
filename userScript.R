library(KOIOS)

##### Input #####

#Load the OMOP Genomic Concept library
concepts <- loadConcepts()

##### Run - Multiple VCFs #####

setwd("C:/Users/ldyer/Documents/KOIOS2.0/KOIOS/")

#Load the VCF directory
vcf <- loadVCF(userVCF = "../KOIOS_testing/VCF/Dana Farber/")

#Set ref to hg19
ref <- "hg19"

concepts.df <- multiVCFPipeline(vcf, ref, concepts)

concepts.df.filt <- concepts.df[!is.na(concepts.df$concept_id),]



##### Run - Individual VCFs #####

#Load the VCF file
vcf <- loadVCF(userVCF = "C:/Users/ldyer/Documents/KOIOS2.0/KOIOS_testing/VCF/Dana Farber/DF1000.vcf")

#Set the reference genome to "auto"
ref <- "hg19"

ref.df <- loadReference(ref)

vcf.df <- processVCF(vcf)
vcf.df <- generateHGVSG(vcf = vcf.df, ref = ref.df)
vcf.df <- processClinGen(vcf.df, ref = ref, progressBar = F)
vcf.df <- addConcepts(vcf.df, concepts, returnAll = T)
