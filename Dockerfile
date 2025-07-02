FROM ubuntu:22.04
COPY environment.yml .

# Install software
RUN apt-get update && \
    apt-get install -y tabix
RUN apt-get clean

# Install bcftools
ENV BCFTOOLS_VERSION=1.20
WORKDIR "/opt"
RUN wget https://github.com/samtools/bcftools/releases/download/${BCFTOOLS_VERSION}/bcftools-${BCFTOOLS_VERSION}.tar.bz2 && \
    tar xvfj bcftools-${BCFTOOLS_VERSION}.tar.bz2 && \
    cd bcftools-${BCFTOOLS_VERSION} && \
    ./configure && \
    make && \
    make Install

# Install VT

