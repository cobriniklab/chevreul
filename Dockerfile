# These are the steps to set up a containerized docker version of our single
# cell analysis apps. Shiny apps run using the shinyproxy service which itself
# will be containerized so that the whole operation can be run on a host system
# with minimal institutional support.
#
# 1. build the shinyapp docker image:
# `docker build -f Dockerfile --build-arg GITHUB_PAT=$PAT -t whtns/chevreul:latest .`
#
# * if troubleshooting package install run:
# `docker build -f \
# Dockerfile.shinyapp --build-arg GITHUB_PAT=$PAT -t \
# whtns/chevreul:latest . --build-arg CACHEBUST=$(date +%s)`
#
# 2. create a docker network called chevreul-network:
# `sudo docker network create chevreul-net`
#
# 3. edit the application.yml file to refer to the appropriate docker images
# and containers
# - id: seuratApp
# container-cmd: ["R", "-e", "shiny::runApp('/root/dockerapp')"]
# container-image: whtns/chevreul
# access-groups: scientists
# container-volumes: ["/var/www/html/dataVolume/storage/single_cell_projects/shinyproxy/dockerdata:/root/dockerdata"]
# container-network: chevreul-net
#
# 4. build the shinyproxy docker image
# `docker build -f Dockerfile.shinyproxy -t whtns/seurattools_container:latest .`
#
# 5. run the shinyproxy docker image with
# `sudo docker run -v /dataVolume/storage/single_cell_projects/shinyproxy/dockerdata:/root/dockerdata -v /var/run/docker.sock:/var/run/docker.sock:ro --group-add $(getent group docker | cut -d: -f3) --net seurattools-net -p 8080:8080 whtns/seurattools_container`


# shinyproxy
# FROM openanalytics/r-base
FROM openanalytics/r-ver:4.4.0

MAINTAINER Kevin Stachelek "kevin.stachelek@gmail.com"

RUN apt-get update && apt-get install --no-install-recommends -y \
    libsqlite3-0

RUN apt-get update && apt-get install --no-install-recommends -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    libssl3 \
    libhdf5-dev \
    libboost-all-dev \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    librsvg2-dev \
    cmake \
    build-essential \
    libglpk40 \
    libbz2-dev \
    liblzma-dev \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install --no-install-recommends -y \
    tk-dev

# system library dependency for the euler app
RUN apt-get update && apt-get install -y \
    libmpfr-dev \
    && rm -rf /var/lib/apt/lists/*

ARG GITHUB_PAT
ENV GITHUB_PAT=$GITHUB_PAT
RUN R -e 'install.packages("remotes")'
RUN R -e 'install.packages("sf")'
RUN R -e "install.packages('igraph', dependencies = T, repos='https://cloud.r-project.org/')"
RUN R -e 'install.packages("BiocManager")'
RUN R -e 'BiocManager::install(version = "3.20")'
RUN R -e 'BiocManager::install("S4Vectors")'
RUN R -e "options(warn=2); install.packages('matrixStats', repos='https://cloud.r-project.org/')"
RUN R -e 'options(warn=2); BiocManager::install("DelayedArray")'
RUN R -e 'BiocManager::install("DelayedMatrixStats")'
RUN R -e 'BiocManager::install("limma")'
RUN R -e 'BiocManager::install("SummarizedExperiment")'
RUN R -e 'BiocManager::install("SingleCellExperiment")'
RUN R -e 'BiocManager::install("batchelor")'
RUN R -e 'BiocManager::install("pcaMethods")'
RUN R -e 'BiocManager::install("Biobase")'
RUN R -e 'BiocManager::install("tximport")'
RUN R -e 'BiocManager::install("annotables")'
RUN R -e 'BiocManager::install("genefilter")'
RUN R -e 'BiocManager::install("wiggleplotr")'
RUN R -e 'BiocManager::install("ensembldb")'
ARG GITHUB_PAT
ENV GITHUB_PAT=$GITHUB_PAT
RUN R -e 'install.packages("clustree", dependencies=TRUE)'
RUN R -e 'install.packages("ggpubr", dependencies=TRUE)'

# install dependencies of the euler app
RUN R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('Rmpfr', repos='https://cloud.r-project.org/')"

RUN R -e 'install.packages("R.utils", repos="https://cloud.r-project.org/")'

RUN apt-get update && apt-get install -y python3 python3-pip
RUN pip3 install matplotlib

RUN R -e 'install.packages("tidyverse")'
RUN R -e 'BiocManager::install("InteractiveComplexHeatmap")'
RUN R -e 'BiocManager::install("plyranges")'

RUN R -e 'install.packages("matrixStats")'
RUN R -e 'install.packages("RSQLite")'
RUN R -e 'BiocManager::install("EnsDb.Hsapiens.v86")'

# Custom cache invalidation
ARG CACHEBUST=1

RUN R -e 'install.packages("formattable")'

RUN R -e "options(warn=2); install.packages('matrixStats', repos='https://cloud.r-project.org/')"
RUN R -e 'options(warn=2); BiocManager::install("scran", site_repository="https://cloud.r-project.org/")'
RUN R -e 'options(warn=2); BiocManager::install("scater", site_repository="https://cloud.r-project.org/")'
RUN R -e 'options(warn=2); remotes::install_github("cobriniklab/chevreulProcess")'
RUN R -e 'options(warn=2); remotes::install_github("cobriniklab/chevreulPlot")'
RUN R -e 'options(warn=2); BiocManager::install("rhdf5")'
RUN R -e 'options(warn=2); BiocManager::install("alabaster.base")'
RUN R -e 'options(warn=2); remotes::install_github("cobriniklab/chevreulShiny")'
RUN R -e 'options(warn=2); remotes::install_github("cobriniklab/chevreul")'

COPY Rprofile.site /usr/local/lib/R/etc/

# Custom cache invalidation
ARG CACHEBUST=2

RUN mkdir /root/dockerapp
COPY dockerapp /root/dockerapp
# copy the app to the image
RUN mkdir /root/euler
COPY euler /root/euler
CMD ["R", "-e", "shiny::runApp('/root/dockerapp')"]
