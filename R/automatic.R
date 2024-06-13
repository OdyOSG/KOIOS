#' Run the default pipeline on a set of VCF objects submitted as a directory input
#' @param vcf A vcf object read by loadVCF(), containing a list of VCF files
#' @param ref A reference specification for the original reference genome, one of "hg18", "hg19", "hg38" or "auto"
#' @param concepts A concept set derived from loadConcepts()
#' @return A list containing the relevant set of outputs for a list of VCF files
#' @export
multiVCFPipeline <- function(vcf, ref, concepts){

  ref.df <- loadReference(ref)

  concepts.df.All <- as.data.frame(matrix(ncol = 11))[-1,]
  colnames(concepts.df.All) <- c("Allele#", "concept_id", "hgvsg", "variantClinGenURL", "varType", "geneSymbol", "chr",
                                 "ref", "concept_name", "concept_class_id","fileName")

  start <- proc.time()[3]

  for(i in c(1:length(vcf))){

    progress(x = i, max = length(vcf))
    eta(x = i, max = length(vcf), start)

    if(length(vcfR::getFIX(vcf[[i]])) < 1){
      next
    }

    tempName <- names(vcf)[i]
    tempVCF <- vcf[[i]]

    vcf.df <- processVCF(tempVCF)
    vcf.df <- generateHGVSG(vcf.df = vcf.df, ref.df = ref.df)
    vcf.df <- processClinGen(vcf.df, ref = ref, progressBar = F)

    concepts.df <- addConcepts(vcf.df, concepts, returnAll = T)
    concepts.df$fileName <- tempName

    concepts.df.All <- rbind(concepts.df.All,concepts.df)
  }

  return(concepts.df.All)

}

