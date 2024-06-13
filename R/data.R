#' Default Concept Vocabulary
#'
#' A loadable concept vocabulary for OMOP Genomic
#' @format A data frame containing genomic variants
#' \describe{
#'   \item{concept_id}{OMOP Concept ID}
#'   \item{concept_name}{OMOP Concept Name}
#'   \item{concept_synonym_name}{OMOP Concept Synonyms in HGVSG format}
#'   \item{ver}{Specific version of reference genome}
#' }
"concepts"

#' Extended Concept Vocabulary
#'
#' An extended loadable concept vocabulary for OMOP Genomic
#' @format A data frame containing genomic variants
#' \describe{
#'   \item{concept_id}{OMOP Concept ID}
#'   \item{concept_name}{OMOP Concept Name}
#'   \item{concept_synonym_name}{OMOP Concept Synonyms in HGVSG format}
#'   \item{concept_class_id}{Specific identity of origin}
#' }
"concepts_ext"

#' Fusion Concept Vocabulary
#'
#' A loadable concept vocabulary for OMOP Genomic gene fusions
#' @format A data frame containing genomic variants
#' \describe{
#'   \item{concept_id}{OMOP Concept ID}
#'   \item{concept_name}{OMOP Concept Name}
#'   \item{concept_synonym_name}{OMOP Concept Synonyms in HGVSG format}
#'   \item{ver}{Specific identity of origin}
#' }
"concepts_fusion"

#' Fusion Concept Vocabulary
#'
#' A loadable concept vocabulary for OMOP Genomic gene fusions
#' @format A data frame containing reference data for hg18, hg19 and hg38
#' \describe{
#'   \item{SequenceName}{}
#'   \item{SequenceRole}{}
#'   \item{AssignedMolecule}{}
#'   \item{GenBankAccn}{}
#'   \item{Relationship}{}
#'   \item{RefSeqAccn}{}
#'   \item{AssemblyUnit}{}
#'   \item{SequenceLength}{}
#'   \item{UCSCStyleName}{}
#'   \item{circular}{}
#'   \item{assembly}{}
#' }
"refData"
