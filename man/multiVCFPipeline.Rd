% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/automatic.R
\name{multiVCFPipeline}
\alias{multiVCFPipeline}
\title{Run the default pipeline on a set of VCF objects submitted as a directory input}
\usage{
multiVCFPipeline(vcf, ref, generateAll, concepts)
}
\arguments{
\item{vcf}{A vcf object read by loadVCF(), containing a list of VCF files}

\item{ref}{A reference specification for the original reference genome, one of "hg18", "hg19", "hg38" or "auto"}

\item{generateAll}{A reference specification for the original reference genome, one of "hg18", "hg19", "hg38" or "auto"}

\item{concepts}{A concept set derived from loadConcepts()}
}
\value{
A list containing the relevant set of outputs for a list of VCF files
}
\description{
Run the default pipeline on a set of VCF objects submitted as a directory input
}
