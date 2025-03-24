
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

This package includes a set of Shiny apps for exploring single cell RNA
sequencing (scRNA-seq) datasets processed as
<a href="https://bioconductor.org/packages/devel/bioc/vignettes/SingleCellExperiment/inst/doc/intro.html" target="_blank" rel="noopener noreferrer">SingleCellExperiments</a>

A demo with a developing human retina scRNA-seq dataset from Shayler et
al. is available
<a href="http://cobrinik-1.saban-chla.usc.edu:8080/app/objectApp" target="_blank" rel="noopener noreferrer">here</a>

There are also convenient functions for:

- Clustering and dimensionality reduction of raw sequencing data.
- Integration (batch correction)
- Louvain clustering at a range of resolutions
- Cell cycle state regression and labeling

> \[!WARNING\] chevreul was designed for full-length smart-seq based
> single cell data. Default settings may not be appropriate for droplet
> (10x) data, though most can be adjusted. Keep in mind best practices
> regarding normalization, dimensional reduction, etc. when using.

## Installation instructions

Chevreul depends on a minimum R version 4.4. The current  
Chevreul loads three [Bioconductor](http://bioconductor.org/) packages

1.  [`chevreulProcess`](https://github.com/cobriniklab/chevreulProcess)
2.  [`chevreulPlot`](https://github.com/cobriniklab/chevreulPlot)
3.  [`chevreulShiny`](https://github.com/cobriniklab/chevreulShiny)

These enable standardized processing, plotting, and interactive analysis
of SingleCellExperiments, respectively.

`Chevreul` depends on a minimum R version \>=4.4 Get the latest stable
`R` release from [CRAN](http://cran.r-project.org/). Then install
`chevreul` and its dependencies using the following code:

``` r
install.packages("remotes")
install.packages("BiocManager")
BiocManager::install("cobriniklab/chevreul")
```

### Troubleshooting installation

#### Dependency management

When installing an R package like Chevreul with many dependencies,
conflicts with existing installations can arise. This is a common issue
in R package management. Here are some strategies to address this
problem:

1.  Consider
    <a href="https://rstudio.github.io/renv/articles/renv.html" target="_blank" rel="noopener noreferrer">renv</a>
    for dependency management. This tool creates isolated environments
    for each project, ensuring that package versions don’t conflict
    across different projects.

2.  Use the conflicted Package The
    <a href="https://conflicted.r-lib.org" target="_blank" rel="noopener noreferrer">conflicted</a>
    package provides an alternative conflict resolution strategy. It
    makes every conflict an error, forcing you to choose which function
    to use

#### Slow internet connection

When installing R packages on slow internet connections, several issues
can arise, particularly with larger packages or when using functions
like remotes::install_github(). Here are some strategies to address
bandwidth-related problems:

Set a longer timeout for downloads: `options(timeout = 9999999)`

Specify the download method: `options(download.file.method = "libcurl")`

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
data("small_example_dataset")
sce_clustering_workflow(small_example_dataset, experiment_name = "tiny_sce", organism = "human")
```

## Get a first look at a processed dataset using an interactive shiny app

``` r
data("tiny_sce")
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

## Integration implementation

Chevreul implements integration (batch correction) of scRNA-seq datasets
using the
<a href="https://bioconductor.org/packages/devel/bioc/vignettes/batchelor/inst/doc/correction.html" target="_blank" rel="noopener noreferrer">batchelor</a>
package. Default settings rely on the `correctExperiments()` function to
preserve pre-existing data and metadata from input objects in the
corrected output.

## Hardware requirements

Recommended minimum hardware requirements for running Chevreul are as
follows:

- RAM: A minimum of 16 GB RAM is recommended for initial analysis.
  However, for larger datasets or more complex analyses, 64 GB or more
  is advisable.
- CPU: Having multiple cores can be beneficial for parallel processing.
- Storage: Sufficient storage space is necessary, especially for
  temporary files. The exact amount depends on the size of your datasets
- R Version: Chevruel requires R version 4.4 or greater

It’s important to note that these requirements can vary based on the
size and complexity of your dataset. As the number of cells increases,
so do the hardware requirements. For instance: A dataset with around
8,000 cells can be analyzed with 8 GB of RAM. For larger datasets or
more complex analyses, 64-128 GB of RAM can be beneficial.
