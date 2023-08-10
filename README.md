<!-- README.md is generated from README.Rmd. Please edit that file -->

## Overview

KOIOS is a tool that is used to generate a set of OMOP Concept IDs, and
related information, from a given VCF file, utilizing resources provided
by ClinVar.

## Installation

KOIOS can presently be installed directly from GitHub:

    # install.packages("devtools")
    devtools::install_github("odyOSG/KOIOS")

## Usage

Users may simply run KOIOS according to the following commands,
replacing the relevant information:


    library(KOIOS)

    concepts <- loadConcepts()

    vcf <- loadVCF(userVCF = "Input VCF")

    ref <- "hg19"

    ref.df <- loadReference(ref)

    vcf.df <- processVCF(vcf)

    vcf.df <- generateHGVSG(vcf = vcf.df, ref = ref.df)

    alleles.df <- processClinGen(vcf.df,ref,generateAll = generateTranscripts)

    concepts.df <- addConcepts(alleles.df, concepts)

If the user is unaware of the reference genome used to generate a given
VCF file, they may use the “automatic” mode found within the
userScript.R file, or alternatively run the following command:


    vcf <- loadVCF(userVCF = "Input VCF")
    ref <- findReference(vcf)

## Getting help

If you encounter a clear bug, please file an issue with a minimal
[reproducible example](https://reprex.tidyverse.org/) at the [GitHub
issues page](https://github.com/OdyOSG/KOIOS/issues).
