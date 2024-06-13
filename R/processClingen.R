#' Process a vcf.df dataframe to return clingen data for all variants
#' @param vcf.df Input vcf.df object
#' @param ref A string indicating the reference genome used
#'                Must be one of: hg18
#'                                hg19
#'                                hg38
#' @param progressBar A toggle indicating whether or not a progress bar will be displayed
#' @return A dataframe containing data derived from the relevant ClinGen URL
#' for each allele found corresponding to a vcf row
#' @export
processClinGen <- function(vcf.df, ref, progressBar = TRUE){

  clinRef <- ifelse(ref=="hg38","GRCh38",
                    ifelse(ref=="hg19","GRCh37","NCBI36"))

  start <- proc.time()[3]

  vcf.df$koios_hgvsg <- ""

  for(i in c(1:length(vcf.df$koios_hgvsg))) {

    if(progressBar == TRUE){
      progress(x = i, max = length(vcf.df$URL))
      eta(x = i, max = length(vcf.df$URL), start)
    }

    vcf.df[i,]$koios_hgvsg <- vcf.df[i,]$hgvsg

  }

  return(vcf.df)

}

#' Adds concept information to an alleles.df dataframe
#' @param vcf.df An alleles.df dataframe returned by
#' @param concepts The ATHENA concept set, derived from loadConcepts (or User input)
#' @param returnAll A paramatere indicating whether or not to return results
#' not in the OMOP Genomic vocab
#' @return A dataframe containing only alleles found in the OMOP Genomic vocab
#' and their associated data
#' @export
addConcepts <- function(vcf.df, concepts, returnAll = FALSE) {

  fullDat <- merge(vcf.df,concepts[,c(1:3)],
                   by.x = "koios_hgvsg",
                   by.y = "concept_synonym_name",
                   all.x = TRUE) %>%
    dplyr::distinct()

  return(fullDat)

}
