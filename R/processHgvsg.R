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

  ref.df <- utils::read.csv(paste(here::here("data/reference/"),"/",ref,".csv",sep=""))[,-1]

  vcf.df <- as.data.frame(vcfR::getFIX(.data$vcf))

  colnames(vcf.df) <- c("CHROM","POS","ID","REF","ALT","QUAL","FILTER")

  return(vcf.df)

}

#' Process a single vcfR object to return a dataframe containing hgvsg notation
#' @param vcf.df Input vcf.df object
#' @param ref A ref.df object containing chrom specifications
#' @return A dataframe containing hgvsg notation for all variants
#' @export
generateHGVSG <- function(vcf.df, ref){

  vcf.df <- vcf.df %>%
    dplyr::mutate(REF_L = stringr::str_length(.data$REF), ALT_L = stringr::str_length(.data$ALT)) %>%
    dplyr::mutate(TYPE = ifelse(.data$REF_L == 1 & .data$ALT_L == 1, "SNP",
                                ifelse(.data$REF_L > .data$ALT_L & .data$ALT_L == 1, "DEL",
                                       ifelse(.data$ALT_L > .data$REF_L & .data$REF_L == 1, "INS", "DELINS")))) %>%
    dplyr::select(.data$CHROM,.data$POS,.data$REF,
                  .data$REF_L,.data$ALT,.data$ALT_L,
                  .data$TYPE)

  vcf.df$hgvsg <- apply(vcf.df, 1, FUN = function(x)
    hgvsgConvert(row = x, ref = .data$ref.df))

  return(vcf.df)

}

#' Generate a hgvsg string
#' @param row A vcf.df row
#' @param ref A ref.df object containing chrom specifications
#' @return A single hgvsg string
#' @export
hgvsgConvert <- function(row,ref){

  if("chr" %in% row[1]){
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
    hgvsg <- paste(Chr,":g.",row[2],"_",modPOS,"delins",row[5],sep="")
  }

  return(hgvsg)

}
