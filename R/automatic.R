#' Attempt to uncover the underlying reference genome used to generate a given VCF file
#' @param vcf A vcf object read by loadVCF()
#' @return A string indicating the reference genome used
#' @export
findReference <- function(vcf){
  vcf.df <- processVCF(vcf)

  vcf.snv <- vcf.df[stringr::str_length(vcf.df$REF) == 1 & stringr::str_length(vcf.df$ALT) == 1,]

  if(dim(vcf.snv)[1] < 15){
    message("Less than 15 SNVs detected. Sampling indels.")
    vcf.snv <- vcf.df
    if(dim(vcf.snv)[1] > 50){
      vcf.snv <- vcf.snv[sample(x = dim(vcf.snv)[1], size = 50, replace = F),]
    } else{
      message("Less than 50 variants detected. Manual reference check reccomended.")
    }
  } else {
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

  return(ref)
}
