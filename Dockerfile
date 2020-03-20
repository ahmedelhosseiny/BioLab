FROM ubuntu:18.04

LABEL description="Bioinformatics Docker Container"
LABEL maintainer="amoustafa@aucegypt.edu"

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

##########################################################################################
##########################################################################################

RUN apt-get update ; apt-get -y upgrade
RUN apt-get -y install git

##########################################################################################
##########################################################################################

ARG SETUPDIR=/tmp/biolabsetup/
RUN mkdir -p $SETUPDIR
WORKDIR $SETUPDIR
RUN git clone https://github.com/ahmedmoustafa/BioLab

##########################################################################################
##########################################################################################

RUN git pull ; sh $SETUPDIR/BioLab/scripts/prerequisites.sh
RUN git pull ; sh $SETUPDIR/BioLab/scripts/programming.sh

