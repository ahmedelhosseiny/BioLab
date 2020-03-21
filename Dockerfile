FROM ubuntu:18.04

LABEL description="Bioinformatics Docker Container"
LABEL maintainer="amoustafa@aucegypt.edu"

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

##########################################################################################
##########################################################################################

RUN apt-get update && \
apt-get -y upgrade && \
apt-get -y install apt-utils dialog software-properties-common

##########################################################################################
##########################################################################################

ARG SETUPDIR=/tmp/biolabsetup/
RUN mkdir -p $SETUPDIR
WORKDIR $SETUPDIR

##########################################################################################
##########################################################################################

# Prerequisites
###############
###############

RUN apt-get -y install vim nano emacs rsync curl wget screen htop parallel gnupg lsof git locate unrar bc aptitude unzip bison flex \
build-essential libtool autotools-dev automake autoconf cmake \
libboost-dev libboost-all-dev libboost-system-dev libboost-program-options-dev libboost-iostreams-dev libboost-filesystem-dev \
gfortran libgfortran3 default-jre default-jdk ant python python-pip python-dev python3.7 python3.7-dev python3-pip python3-venv \
libssl-dev libcurl4-openssl-dev \
libxml2-dev \
libmagic-dev \
hdf5-* libhdf5-* \
fuse libfuse-dev \
libtbb-dev \
liblzma-dev libbz2-dev \
libbison-dev \
libgmp3-dev \
libncurses5-dev libncursesw5-dev \
liblzma-dev \
caffe-cpu

##########################################################################################
##########################################################################################

# Progamming
############
############

# BioPerl
#########
RUN apt-get -y install bioperl

# Biopython
###########
RUN pip install --no-cache-dir -U biopython numpy pandas matplotlib scipy seaborn plotly bokeh scikit-learn tensorflow keras torch theano && \
pip3 install --no-cache-dir -U biopython numpy pandas matplotlib scipy seaborn statsmodels plotly bokeh scikit-learn tensorflow keras torch theano

# R
###
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' && \
apt-get update && \
apt-get -y install r-base r-base-dev && \
R -e "install.packages (c('tidyverse', 'tidylog', 'readr', 'dplyr', 'knitr', 'printr', 'rmarkdown', 'shiny', \
'ggplot2', 'gplots', 'plotly', 'rbokeh', 'circlize', 'RColorBrewer', 'formattable', \
'reshape2', 'data.table', 'readxl', 'devtools', 'cowplot', 'tictoc', 'ggpubr', 'patchwork', 'reticulate', \
'randomForest', 'randomForestExplainer', 'forestFloor', 'randomForestSRC', 'ggRandomForests', 'xgboost', 'gbm', 'iml', \
'vegan', 'BiocManager'))" && \
R -e "BiocManager::install(c('DESeq2', 'edgeR', 'dada2', 'phyloseq', 'metagenomeSeq'), ask = FALSE, update = TRUE)" && \
R -e "install.packages('tensorflow')" && R -e "library(tensorflow) ; install_tensorflow()" && \
R -e "devtools::install_github('rstudio/keras')" && R -e "library(keras) ; install_keras()"

##########################################################################################
##########################################################################################

# NCBI Tools
############
############

RUN mkdir -p $SETUPDIR/ncbi && $SETUPDIR/ncbi && \
git clone https://github.com/ncbi/ncbi-vdb.git && cd $SETUPDIR/ncbi/ncbi-vdb && ./configure && make && make install && \
git clone https://github.com/ncbi/ngs.git && cd $SETUPDIR/ncbi/ngs && ./configure && make && make install && \
git clone https://github.com/ncbi/ngs-tools.git && cd $SETUPDIR/ncbi/ngs-tools && ./configure && make && make install && \
git clone https://github.com/ncbi/sra-tools.git && cd $SETUPDIR/ncbi/sra-tools && ./configure && make && make install && \
cd $SETUPDIR/ncbi/ngs/ngs-sdk && ./configure && make && make install && \
cd $SETUPDIR/ncbi/ngs/ngs-python && ./configure && make && make install && \
cd $SETUPDIR/ncbi/ngs/ngs-java && ./configure && make && make install && \
cd $SETUPDIR/ncbi/ngs/ngs-bam && ./configure && make && make install

##########################################################################################
##########################################################################################

