#' Process a vcfR object, or list of vcfR objects, to return a dataframe
#' containing hgvsg notation for all variants, as well as all clingen urls
#' @param vcfR Input vcfR object
#' @param ref A string indicating the reference genome used
#'                Must be one of: hg18
#'                                hg19
#'                                hg38
#' @return A dataframe containing hgvsg notation and clingen urls for all variants
#' @export
processVCF <- function(vcfR, ref){

  ref.df <- read.csv(paste(here::here("data/reference/"),"/",ref,".csv",sep=""))[,-1]

  vcf.df <- as.data.frame(vcfR::getFIX(vcf))

}

#' Process a single vcfR object to return a dataframe containing hgvsg notation
#' @param vcf Input vcf.df object
#' @param ref A ref.df object containing chrom specifications
#' @return A dataframe containing hgvsg notation for all variants
#' @export
generateHGVSG <- function(vcf, ref){

  vcf.df <- vcf %>%
    dplyr::mutate(REF_L = stringr::str_length(REF), ALT_L = stringr::str_length(ALT)) %>%
    dplyr::mutate(TYPE = ifelse(REF_L == 1 & ALT_L == 1, "SNP",
                                ifelse(REF_L > ALT_L & ALT_L == 1, "DEL",
                                       ifelse(ALT_L > REF_L & REF_L == 1, "INS", "DELINS")))) %>%
    dplyr::select(CHROM,POS,REF,REF_L,ALT,ALT_L,TYPE)

  vcf.df$hgvsg <- apply(vcf.df, 1, FUN = function(x)
    hgvsgConvert(row = x, ref = ref.df))

  return(vcf.df)

}

#' Generate a hgvsg string
#' @param row A vcf.df row
#' @param ref A ref.df object containing chrom specifications
#' @return A single hgvsg string
#' @export
hgvsgConvert <- function(row,ref){

  CHROM = row[1]
  POS = row[2]


  if("chr" %in% CHROM){
    row[1] <- gsub("chr|chr ","",row[1])
  }

  Chr <- ref[ref$Molecule_name == row[1],]$RefSeq_sequence

  if(row[7] == "SNP"){
    hgvsg <- paste(Chr,":g.",row[2],row[3],">",row[5],sep="")
  } else if(row[7] == "DEL"){
    modPOS <- as.numeric(row[2])-as.numeric(row[6])
    hgvsg <- paste(Chr,":g.",row[2],"_",modPOS,"del",sep="")
  } else if(row[7] == "INS"){
    modPOS <- as.numeric(row[2])+1
    hgvsg <- paste(Chr,":g.",row[2],"_",modPOS,"ins",sep="")
  } else if(row[7] == "DELINS"){
    modPOS <- as.numeric(row[2])+1
    hgvsg <- paste(Chr,":g.",row[2],"_",modPOS,"delins",ALT,sep="")
  }

  return(hgvsg)

}
