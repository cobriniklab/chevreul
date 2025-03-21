
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Chevreul

<!-- badges: start -->

[![GitHub
issues](https://img.shields.io/github/issues/cobriniklab/chevreul)](https://github.com/cobriniklab/chevreul/issues)
[![GitHub
pulls](https://img.shields.io/github/issues-pr/cobriniklab/chevreul)](https://github.com/cobriniklab/chevreul/pulls)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Codecov test
coverage](https://codecov.io/gh/cobriniklab/chevreul/graph/badge.svg)](https://app.codecov.io/gh/cobriniklab/chevreul)
<!-- badges: end -->

# chevreul

This package includes a set of Shiny apps for exploring single cell RNA
datasets processed as a SingleCellExperiment

A demo using a human gene transcript dataset from Shayler et al. is
available
<a href="http://cobrinik-1.saban-chla.usc.edu:8080/app/objectApp" target="_blank" rel="noopener noreferrer">here</a>

There are also convenient functions for:

- Clustering and Dimensional Reduction of Raw Sequencing Data.
- Integration and Label Transfer
- Louvain Clustering at a Range of Resolutions
- Cell cycle state regression and labeling

> \[!WARNING\] chevreul was designed for full-length smart-seq based
> single cell data. Default settings may not be appropriate for droplet
> (10x) data, though most can be adjusted. Keep in mind best practices
> regarding normalization, dimensional reduction, etc. when using.

## Installation instructions

Chevreul loads three [Bioconductor](http://bioconductor.org/) packages

1.  [`chevreulProcess`](https://github.com/cobriniklab/chevreulProcess)
2.  [`chevreulPlot`](https://github.com/cobriniklab/chevreulPlot)
3.  [`chevreulShiny`](https://github.com/cobriniklab/chevreulShiny)

These enable standardized processing, plotting, and interactive analysis
of SingleCellExperiments, respectively.

Get the latest stable `R` release from
[CRAN](http://cran.r-project.org/). Then install `chevreul` and its
dependencies using the following code:

``` r
BiocManager::install("cobriniklab/chevreul")
```

## TLDR

Chevreul provides a single command to:

- construct a SingleCellExperiment object

- filter genes by minimum expression and ubiquity

- normalize and scale expression by any of several methods packaged in
  SingleCellExperiment

## Run clustering on a single object

By default clustering will be run at ten different resolutions between
0.2 and 2.0. Any resolution can be specified by providing the resolution
argument as a numeric vector.

``` r
clustered_sce <- clustering_workflow(tiny_sce,
    experiment_name = "tiny_sce",
    organism = "human"
)
```

## Get a first look at a processed dataset using an interactive shiny app

``` r
minimalChevreulApp(tiny_sce)
```

## Transcript-level quantification

Transcripts may be quantified using any of several methods, including
alignment-free methods best used with well-annotated transcriptomes
(Salmon, Kallisto), alignment-based methods best used to detect novel
isoforms (StringTie2), or long-read methods for use with long-read
sequencing data (IsoQuant). Transcript-level data must be loaded into
the SingleCellExperiment object as an alternative experiment prior to
processing with Chevreul.
