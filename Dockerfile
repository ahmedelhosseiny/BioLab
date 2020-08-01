FROM ubuntu:20.04

LABEL description="Bioinformatics Docker Container"
LABEL maintainer="amoustafa@aucegypt.edu"

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

##########################################################################################
##########################################################################################

RUN apt-get update && \
apt-get -y upgrade && \
apt-get -y install apt-utils dialog software-properties-common

RUN add-apt-repository universe && \
add-apt-repository multiverse && \
add-apt-repository restricted

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
gfortran libgfortran5 \
default-jre default-jdk ant \
python3 python3-dev python3-pip python3-venv \
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
caffe-cpu \
cargo \
ffmpeg \
libmagick++-dev \
libavfilter-dev \
dos2unix

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
RUN pip3 install --no-cache-dir -U biopython numpy pandas matplotlib scipy seaborn statsmodels plotly bokeh scikit-learn tensorflow keras torch theano jupyterlab

# R
###
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/' && \
apt-get update && \
apt-get -y install r-base r-base-dev && \
R -e "install.packages (c('tidyverse', 'tidylog', 'readr', 'dplyr', 'knitr', 'printr', 'rmarkdown', 'shiny', \
'ggplot2', 'gplots', 'plotly', 'rbokeh', 'circlize', 'RColorBrewer', 'formattable', \
'reshape2', 'data.table', 'readxl', 'devtools', 'cowplot', 'tictoc', 'ggpubr', 'patchwork', 'reticulate', \
'randomForest', 'randomForestExplainer', 'randomForestSRC', 'ggRandomForests', 'xgboost', 'gbm', 'iml', \
'vegan', 'BiocManager'))" && \
R -e "BiocManager::install(c('DESeq2', 'edgeR', 'dada2', 'phyloseq', 'metagenomeSeq'), ask = FALSE, update = TRUE)"

##########################################################################################
##########################################################################################

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10

##########################################################################################
##########################################################################################

# NCBI Tools
############
############

RUN mkdir -p $SETUPDIR/ncbi && cd $SETUPDIR/ncbi && \
git clone https://github.com/ncbi/ncbi-vdb.git && \
git clone https://github.com/ncbi/ngs.git && \
git clone https://github.com/ncbi/ngs-tools.git && \
git clone https://github.com/ncbi/sra-tools.git && \
cd $SETUPDIR/ncbi/ncbi-vdb && ./configure && make && make install && \
cd $SETUPDIR/ncbi/ngs && ./configure && make && make install && \
cd $SETUPDIR/ncbi/ngs/ngs-sdk && ./configure && make && make install && \
cd $SETUPDIR/ncbi/ngs/ngs-python && ./configure && make && make install && \
cd $SETUPDIR/ncbi/ngs/ngs-java && ./configure && make && make install && \
cd $SETUPDIR/ncbi/ngs/ngs-bam && ./configure && make && make install && \
cd $SETUPDIR/ncbi/sra-tools && ./configure && make && make install && \
cd $SETUPDIR/ncbi/ngs-tools && ./configure && make && make install

RUN cd $SETUPDIR/ncbi && \
curl -o datasets 'https://ftp.ncbi.nlm.nih.gov/pub/datasets/command-line/LATEST/linux-amd64/datasets' && \
chmod +x datasets && \
mv datasets /usr/local/bin/

##########################################################################################
##########################################################################################

# Sequence Processing
#####################
#####################

# FASTX
#######
RUN cd $SETUPDIR/ && \
git clone https://github.com/agordon/libgtextutils.git && cd $SETUPDIR/libgtextutils/ && \
./reconf && ./configure && make && make install && \
cd $SETUPDIR/ && \
git clone https://github.com/agordon/fastx_toolkit.git && cd $SETUPDIR/fastx_toolkit && \
wget -t 0 https://github.com/agordon/fastx_toolkit/files/1182724/fastx-toolkit-gcc7-patch.txt && \
patch -p1 < fastx-toolkit-gcc7-patch.txt && \
./reconf && ./configure && make && make install

# Trimmomatic
#############
RUN cd $SETUPDIR/ && \
git clone https://github.com/timflutre/trimmomatic.git && \
cd $SETUPDIR/trimmomatic && \
make && make install INSTALL="/usr/local/"

# SeqKit
########
RUN cd $SETUPDIR/ && \
wget -t 0 https://github.com/shenwei356/seqkit/releases/download/v0.13.2/seqkit_linux_amd64.tar.gz && \
tar zxvf seqkit_linux_amd64.tar.gz && \
mv seqkit /usr/local/bin/

# fastp
#######
RUN cd $SETUPDIR/ && \
git clone https://github.com/OpenGene/fastp.git && \
cd $SETUPDIR/fastp && \
make && make install

# HTStream
##########
RUN cd $SETUPDIR/ && \
wget -t 0 https://github.com/s4hts/HTStream/releases/download/v1.3.0-release/HTStream_v1.3.0-release.tar.gz && \
tar zxvf HTStream_v1.3.0-release.tar.gz && \
mv hts_* /usr/local/bin/

# fqtrim
########
RUN cd $SETUPDIR/ && \
wget -t 0 http://ccb.jhu.edu/software/fqtrim/dl/fqtrim-0.9.7.tar.gz && \
tar zxvf fqtrim-0.9.7.tar.gz && \
cd $SETUPDIR/fqtrim-0.9.7/ && \
make && mv fqtrim /usr/local/bin/

# seqmagick
###########
RUN pip3 install --no-cache-dir -U seqmagick

# seqtk
#######
RUN git clone https://github.com/lh3/seqtk.git && \
cd seqtk && \
make && \
mv seqtk /usr/local/bin/


##########################################################################################
##########################################################################################

# Sequence Search
#################
#################

# BLAST & HMMER
###############
RUN apt-get -y install ncbi-blast+ hmmer
RUN cd $SETUPDIR/ && wget -t 0 http://github.com/bbuchfink/diamond/releases/download/v2.0.0/diamond-linux64.tar.gz && tar zxvf diamond-linux64.tar.gz && mv diamond /usr/local/bin/

##########################################################################################
##########################################################################################

# Alignment Tools
#################
#################

# JAligner
##########
RUN apt-get -y install jaligner

# MUSCLE
########
RUN cd $SETUPDIR/ && \
wget -t 0 https://www.drive5.com/muscle/downloads3.8.31/muscle3.8.31_src.tar.gz && \
tar zxvf muscle3.8.31_src.tar.gz && \
cd $SETUPDIR/muscle3.8.31/src && \
make && mv muscle /usr/local/bin/

# MAFFT
#######
RUN cd $SETUPDIR/ && \
wget -t 0 https://mafft.cbrc.jp/alignment/software/mafft-7.471-with-extensions-src.tgz && \
tar zxvf mafft-7.471-with-extensions-src.tgz && \
cd $SETUPDIR/mafft-7.471-with-extensions/core && \
make clean && make && make install && \
cd $SETUPDIR/mafft-7.471-with-extensions/extensions/ && \
make clean && make && make install

# BWA
#####
RUN cd $SETUPDIR/ && \
git clone https://github.com/lh3/bwa.git && \
cd $SETUPDIR/bwa && \
make && mv bwa /usr/local/bin/

# TopHat
########
# RUN cd $SETUPDIR/ && \
# wget -t 0 https://ccb.jhu.edu/software/tophat/downloads/tophat-2.1.1.Linux_x86_64.tar.gz && \
# tar zxvf tophat-2.1.1.Linux_x86_64.tar.gz && \
# cd $SETUPDIR/tophat-2.1.1.Linux_x86_64 && \
# mv tophat* /usr/local/bin/

# HISAT2
########
RUN cd $SETUPDIR/ && \
git clone https://github.com/infphilo/hisat2.git && \
cd $SETUPDIR/hisat2 && \
make && mv hisat2-* /usr/local/bin/  &&  mv hisat2 /usr/local/bin/


# Bowtie2
########
RUN cd $SETUPDIR/ && \
git clone https://github.com/BenLangmead/bowtie2.git && \
cd $SETUPDIR/bowtie2/ && \
make && make install


# STAR
######
RUN cd $SETUPDIR/ && \
git clone https://github.com/alexdobin/STAR.git && \
cd $SETUPDIR/STAR/source && \
make STAR && mv STAR /usr/local/bin/


# Salmon
########
RUN cd $SETUPDIR/ && \
wget -t 0 https://github.com/COMBINE-lab/salmon/releases/download/v1.3.0/salmon-1.3.0_linux_x86_64.tar.gz && \
tar zxvf salmon-1.3.0_linux_x86_64.tar.gz && \
mv $SETUPDIR/salmon-latest_linux_x86_64/bin/* /usr/local/bin/ && \
mv $SETUPDIR/salmon-latest_linux_x86_64/lib/* /usr/local/lib/

# kallisto
##########
RUN cd $SETUPDIR/ && \
git clone https://github.com/pachterlab/kallisto.git && \
cd $SETUPDIR/kallisto/ext/htslib && \
autoheader && autoconf && \
cd $SETUPDIR/kallisto/ && \
mkdir build && \
cd $SETUPDIR/kallisto/build && \
cmake .. && make && make install && \
R -e "BiocManager::install('pachterlab/sleuth', ask = FALSE, update = TRUE)"

# BBMap
#######
RUN cd $SETUPDIR/ && \
wget -t 0 https://downloads.sourceforge.net/project/bbmap/BBMap_38.86.tar.gz && \
tar zxvf BBMap_38.86.tar.gz && \
mv bbmap/* /usr/local/bin/

##########################################################################################
##########################################################################################

# BAM Processing
################
################

# HTSlib
########
RUN cd $SETUPDIR/ && \
git clone https://github.com/samtools/htslib.git && \
cd $SETUPDIR/htslib && \
autoheader ; autoconf ; ./configure ; make ; make install

# Samtools
##########
RUN cd $SETUPDIR/ && \
git clone git://github.com/samtools/samtools.git && \
cd $SETUPDIR/samtools && \
autoheader ; autoconf ; ./configure ; make ; make install

# Bcftools
##########
RUN cd $SETUPDIR/ && \
git clone https://github.com/samtools/bcftools.git && \
cd $SETUPDIR/bcftools && \
autoheader ; autoconf ; ./configure ; make ; make install


# Bamtools
##########
RUN cd $SETUPDIR/ && \
git clone git://github.com/pezmaster31/bamtools.git && \
cd $SETUPDIR/bamtools && \
mkdir build && \
cd $SETUPDIR/bamtools/build && \
cmake .. ; make ; make install

# VCFtools
##########
RUN cd $SETUPDIR/ && \
git clone https://github.com/vcftools/vcftools.git && \
cd $SETUPDIR/vcftools && \
./autogen.sh ; ./configure ; make ; make install

# Bedtools
##########
RUN cd $SETUPDIR/ && \
git clone https://github.com/arq5x/bedtools2.git && \
cd $SETUPDIR/bedtools2 && \
make ; make install

# deepTools
###########
RUN cd $SETUPDIR/ && \
git clone https://github.com/deeptools/deepTools && \
cd $SETUPDIR/deepTools && \
python setup.py install

# BEDOPS
########
RUN cd $SETUPDIR/ && \
git clone https://github.com/bedops/bedops.git && \
cd $SETUPDIR/bedops && \
make ; make install ; mv ./bin/* /usr/local/bin/

# SAMBAMBA
##########
RUN cd $SETUPDIR/ && \
wget -t 0 https://github.com/biod/sambamba/releases/download/v0.7.1/sambamba-0.7.1-linux-static.gz && \
gzip -d sambamba-0.7.1-linux-static.gz && \
mv sambamba-0.7.1-linux-static /usr/local/bin/sambamba && \
chmod +x /usr/local/bin/sambamba


##########################################################################################
##########################################################################################

# Assemblers
############
############

# SPAdes
########
RUN cd $SETUPDIR/ && \
wget -t 0 http://cab.spbu.ru/files/release3.14.1/SPAdes-3.14.1-Linux.tar.gz  && \
tar zxvf SPAdes-3.14.1-Linux.tar.gz  && \
mv SPAdes-3.14.1-Linux/bin/* /usr/local/bin/  && \
mv SPAdes-3.14.1-Linux/share/* /usr/local/share/


# ABySS
#######
RUN cd $SETUPDIR/ && \
git clone https://github.com/sparsehash/sparsehash.git && \
cd $SETUPDIR/sparsehash && \
./autogen.sh && ./configure && make && make install && \
cd $SETUPDIR/ && \
git clone https://github.com/bcgsc/abyss.git && \
cd $SETUPDIR/abyss && \
./autogen.sh && ./configure && make && make install


# Velvet
########
RUN cd $SETUPDIR/ && \
git clone https://github.com/dzerbino/velvet.git && \
cd $SETUPDIR/velvet/ && \
make && mv velvet* /usr/local/bin/


# MEGAHIT
#########
RUN cd $SETUPDIR/ && \
git clone https://github.com/voutcn/megahit.git && \
cd $SETUPDIR/megahit && \
git submodule update --init && \
mkdir build && \
cd $SETUPDIR/megahit/build && \
cmake .. -DCMAKE_BUILD_TYPE=Release && make -j4 && make simple_test  && make install


# MetaVelvet
############
RUN cd $SETUPDIR/ && \
git clone git://github.com/hacchy/MetaVelvet.git && \
cd $SETUPDIR/MetaVelvet && \
make && mv meta-velvetg /usr/local/bin/

##########################################################################################
##########################################################################################