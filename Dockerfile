FROM ubuntu:18.04

LABEL description="Bioinformatics Docker Container"
LABEL maintainer="amoustafa@aucegypt.edu"

RUN mkdir -p /tmp/biolabsetup/
WORKDIR /tmp/biolabsetup/

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update ; apt-get -y upgrade
RUN apt-get -y install git

##########################################################################################
##########################################################################################

RUN git clone https://github.com/ahmedmoustafa/BioLab
RUN sh /tmp/biolabsetup/BioLab/scripts/prerequisites.sh
RUN sh /tmp/biolabsetup/BioLab/scripts/programming.sh
