#' Process a vcf.df dataframe to return clingen data for all variants
#' @param vcf.df Input vcf.df object
#' @param ref A string indicating the reference genome used
#'                Must be one of: hg18
#'                                hg19
#'                                hg38
#' @return A dataframe containing data derived from the relevant ClinGen URL
#' for each allele found corresponding to a vcf row
#' @export
processClinGen <- function(vcf.df, ref){

  #Create a handle
  thisHandle <- httr::handle("http://reg.test.genome.network/")

  vcf.df$URL <- paste("http://reg.test.genome.network/allele?hgvs=",vcf.df$hgvsg,sep="")

  returnDat <- as.data.frame(matrix(ncol = 7))
  colnames(returnDat) <- c("Allele#","variantClinGenURL","hgvsg",
                           "varType","geneSymbol","chr","ref")

  k <- 1

  for(i in c(1:length(vcf.df$URL))) {

    tempVCF <- vcf.df[i,]

    urlTest <- httr::GET(handle = thisHandle,
                         path = gsub(thisHandle$url,"",tempVCF$URL),
                         encoding = "UTF-8", as = "text")

    suppressMessages(
      variant <- jsonlite::parse_json(urlTest)
    )

    progress(x = i, max = length(vcf.df$URL))

    genes <- c()

    for(l in c(1:length(variant$transcriptAlleles))){

      genes <- c(genes,variant$transcriptAlleles[[l]]$geneSymbol)

    }

    genes <- paste(unique(genes),collapse = ", ")

    for(j in c(1:length(variant$genomicAlleles))){

      returnDat[k,]$`Allele#` <- k
      returnDat[k,]$variantClinGenURL <- tempVCF$URL
      returnDat[k,]$hgvsg <- variant$genomicAlleles[[j]]$hgvs[[1]]
      returnDat[k,]$geneSymbol <- genes
      returnDat[k,]$varType <- tempVCF$TYPE
      returnDat[k,]$chr <- tempVCF$CHROM
      returnDat[k,]$ref <- ref

      k <- k ++ 1

    }

  }

  return(returnDat)

}


#' Adds
#' @param alleles.df An alleles.df dataframe returned by
#' @param concepts The ATHENA concept set, derived from loadConcepts (or User input)
#' @param returnAll A paramatere indicating whether or not to return results
#' not in the OMOP Genomic vocab
#' @return A dataframe containing only alleles found in the OMOP Genomic vocab
#' and their associated data
#' @export
addConcepts <- function(alleles.df, concepts, returnAll = FALSE) {

  fullDat <- merge(alleles.df,concepts,
                   by.x = "hgvsg",
                   by.y = "concept_synonym_name",
                   all = returnAll)[,c(2,8,1,3,4,5,6,7)] %>%
    dplyr::arrange(.data$`Allele#`)

  return(fullDat)

}
