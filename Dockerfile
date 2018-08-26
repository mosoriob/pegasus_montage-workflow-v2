FROM debian:9

LABEL maintainer "Mats Rynge <rynge@isi.edu>"

RUN apt-get update && apt-get install -y \
        build-essential \
        curl \
        gfortran \
        gnupg \
        libmariadbclient18 \
        libpq5 \
        locales \
        locales-all \
        openjdk-8-jre \
        pkg-config \
        python \
        python-astropy \
        python-future \
        python-dev \
        python-pip \
        unzip \
        vim \
        wget 

#install pegasus
RUN     wget -O - http://download.pegasus.isi.edu/pegasus/gpg.txt | apt-key add - && \
        echo 'deb http://download.pegasus.isi.edu/wms/download/debian stretch main' > \
        /etc/apt/sources.list.d/pegasus.list && \
        apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y pegasus

# add non-root user
RUN useradd  -ms /bin/bash appuser
WORKDIR /home/appuser
USER appuser
ADD --chown=appuser:appuser . /home/appuser/

# build montage
RUN wget -nv https://github.com/Caltech-IPAC/Montage/archive/dev.zip && \
    unzip dev.zip && \
    rm -f dev.zip && \
    mv Montage-dev Montage && \
    cd Montage && \
    make

# copy montage
RUN mkdir montage-workflow-v2
ADD . montage-workflow-v2/ 

# env path 
ENV PATH /home/appuser/Montage/bin/:$PATH
