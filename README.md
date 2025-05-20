
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

This package includes a set of Shiny apps for interactive exploration of
single cell RNA sequencing (scRNA-seq) datasets processed as
<a href="https://bioconductor.org/packages/devel/bioc/vignettes/SingleCellExperiment/inst/doc/intro.html" target="_blank" rel="noopener noreferrer">SingleCellExperiments</a>

A demo with a developing human retina scRNA-seq dataset from Shayler et
al. is available
<a href="https://cobrinik-1.saban-chla.usc.edu/shiny/chevreul_demo/" target="_blank" rel="noopener noreferrer">here</a>

Chevreul includes tools for:

- Interactive data analysis and visualization
- Louvain clustering at a range of resolutions
- Dimensionality reduction of raw sequencing data.
- Integration (batch correction) of multiple datasets

> \[!WARNING\] Chevreul was designed for full-length smart-seq based
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
`Chevreul` and its dependencies using the following code:

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

## Quick Start

After successful installation of the Chevreul package from Bioconductor,
load the package along with the SingleCellExperiment example data
provided with the package.

``` r
# Load packages
library(chevreul)

# Load and view example dataset
data("small_example_dataset")
small_example_dataset
```

### Run clustering on a single object

The `sce_clustering_workflow()` function performs key processing steps,
including quality control filtering, normalization and log
transformation, dimensionality reduction, Louvain clustering across
various resolutions, and the identification of cluster-specific marker
genes or transcripts.

``` r
data("medium_example_dataset")

medium_example_dataset_processed <- sce_clustering_workflow(medium_example_dataset, resolution = 0.6, experiment_name = "sce", organism = "human") 
```

### Get a first look at a processed dataset using an interactive shiny app

The function `minimalChevreulApp` opens an interactive shiny application
that can be used for visualization and exploration of the processed
dataset.

``` r
minimalChevreulApp(tiny_sce)
```

## Transcript-level quantification

For transcript-level analysis, users must incorporate transcript-level
data into the SingleCellExperiment object as an alternative experiment
before initiating the Chevreul processing pipeline. This step is crucial
for enabling detailed exploration at the transcript level.

Transcripts may be quantified using any of several available methods,
including alignment-free methods best used with well-annotated
transcriptomes (Salmon, Kallisto), alignment-based methods best used to
detect novel isoforms (StringTie2), or long-read methods for use with
long-read sequencing data (IsoQuant).

## Integration implementation

The `sce_integrate()` function in Chevreul implements integration (batch
correction) of scRNA-seq datasets by using the
<a href="https://bioconductor.org/packages/devel/bioc/vignettes/batchelor/inst/doc/correction.html" target="_blank" rel="noopener noreferrer">batchelor</a>
package.

It accepts a list of SingleCellExperiment objects as input for
integration and stores the corresponding batch information in a metadata
field named ‘batch’. By default, it employs batchelor’s
`correctExperiments` function to preserve pre-existing data structures
and metadata from input SingleCellExperiment objects within the
integrated output.

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

## Learn More

To learn more about the usage of Bioconductor tools for single-cell
RNA-seq analysis. Consult the book
<a href="https://bioconductor.org/books/release/OSCA/" target="_blank" rel="noopener noreferrer">Orchestrating
Single-Cell Analysis with Bioconductor</a>. The book walks through
common workflows for the analysis of single-cell RNA-seq data
(scRNA-seq). This book will show you how to make use of cutting-edge
Bioconductor tools to process, analyze, visualize, and explore scRNA-seq
data
