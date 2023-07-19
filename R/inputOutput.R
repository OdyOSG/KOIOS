#' Generate a set of processed alignments given a stringDF dataframe
#' @return A set of concept synonyms for the OMOP Genomic dataset, derived from ATHENA
#' @export
loadConcepts <- function(){
  concepts <- read.csv(here::here("data/OMOP_GENOMIC/CONCEPT_SYNONYM.csv"), sep = "\t")
  concepts <- concepts[!is.na(concepts$concept_synonym_name),]
  return(concepts)
}

#' Load a single .vcf file or a set of .vcf's located in a single directory
#' @param userVCF A user-defined .vcf file or a directory containing several .vcf objects
#' @return Either a single vcfR object or a list of vcfR objects
#' @export
loadVCF <- function(userVCF){

  if(file.exists(userVCF) && !dir.exists(userVCF)) {

    vcf <- vcfR::read.vcfR(file = userVCF, verbose = 0)

    return(vcf)

  } else if(dir.exists(userVCF)) {

    outList <- list()
    fileList <- list.files(path = userVCF)

    print(fileList)

    for(file in fileList){

      vcfTemp <- vcfR::read.vcfR(file = paste(here::here(),"/",userVCF,"/",file,sep=""), verbose = 0)
      outList <- append(outList,vcfTemp)

    }

    return(outList)

  }
}
