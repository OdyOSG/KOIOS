#' Attempt to uncover the underlying reference genome used to generate a given VCF file
#' @param vcf A vcf object read by loadVCF()
#' @return A string indicating the reference genome used
#' @export
findReference <- function(vcf){
  vcf.df <- processVCF(vcf)

  #Sample 100 rows
  if(dim(vcf.df)[1] > 100){
    vcf.df <- vcf.df[sample(x = dim(vcf.df)[1], size = 100, replace = F),]
  }

  ref.hg18 <- loadReference("hg18")
  ref.hg19 <- loadReference("hg19")
  ref.hg38 <- loadReference("hg38")

  vcf.hg18 <- generateHGVSG(vcf.df = vcf.df, ref.df = ref.hg18)
  vcf.hg19 <- generateHGVSG(vcf.df = vcf.df, ref.df = ref.hg19)
  vcf.hg38 <- generateHGVSG(vcf.df = vcf.df, ref.df = ref.hg38)

  alleles.hg18 <- processClinGen(vcf.df = vcf.hg18, ref = "hg18", generateAll = F)
  alleles.hg19 <- processClinGen(vcf.df = vcf.hg19, ref = "hg19", generateAll = F)
  alleles.hg38 <- processClinGen(vcf.df = vcf.hg38, ref = "hg38", generateAll = F)

  #Find reference genome
  resultLength <- c(dim(alleles.hg18)[1],dim(alleles.hg19)[1],dim(alleles.hg38)[1])

  #Set reference genome
  ref <- c("hg18","hg19","hg38")[which.max(resultLength)]

  return(ref)
}
