FROM ubuntu:latest

ENV TOOLS=/tools

#Установка необходимых пакетов
RUN apt update && apt install -y \
    build-essential \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
	libncurses5-dev \
    default-jdk \
    wget \
    python3 \
    python3-pip \
	python3-venv \
	git \
	&& apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${TOOLS}

# Установка multiqс
# MULTIQC version 1.21, release date: Feb 28, 2024
RUN git clone https://github.com/ewels/MultiQC.git ${TOOLS}/multiqc-1.21 \
    && python3 -m venv ${TOOLS}/venv \
    && . ${TOOLS}/venv/bin/activate \
    && ${TOOLS}/venv/bin/pip install -e ${TOOLS}/multiqc-1.21

# Установка BWA-MEM2
# BWA-MEM2 version 2.2.1, release date: Mar 17, 2021
RUN wget https://github.com/bwa-mem2/bwa-mem2/releases/latest/download/bwa-mem2-2.2.1_x64-linux.tar.bz2 -O ${TOOLS}/bwa-mem2.tar.bz2 \
    && tar -xjf ${TOOLS}/bwa-mem2.tar.bz2 -C ${TOOLS} \
    && rm ${TOOLS}/bwa-mem2.tar.bz2 \
    && mv ${TOOLS}/bwa-mem2-2.2.1_x64-linux ${TOOLS}/bwa-mem2-2.2.1

# Установка SAMtools
# SAMtools version 1.20, release date: Apr 2024
RUN wget https://github.com/samtools/samtools/releases/latest/download/samtools-1.20.tar.bz2 -O ${TOOLS}/samtools.tar.bz2 \
    && tar -xjf ${TOOLS}/samtools.tar.bz2 -C ${TOOLS} \
    && rm ${TOOLS}/samtools.tar.bz2 \
    && ${TOOLS}/samtools-1.20/configure --prefix=${TOOLS}/samtools-1.20 \
    && make -C ${TOOLS}/samtools-1.20

# Установка Picard
# Picard version 3.1.1, release date: Nov 15, 2023
RUN mkdir -p ${TOOLS}/picard-3.1.1/ \
	&& wget https://github.com/broadinstitute/picard/releases/latest/download/picard.jar -O ${TOOLS}/picard-3.1.1/picard.jar \
	&& chmod 777 ${TOOLS}/picard-3.1.1/picard.jar


ENV PATH="${TOOLS}/bwa-mem2-2.2.1:${TOOLS}/samtools-1.20:${TOOLS}/picard-3.1.1:${TOOLS}/venv/bin:${PATH}"
ENV BWA_MEM2="${TOOLS}/bwa-mem2-2.2.1/bwa-mem2"
ENV SAMTOOLS="${TOOLS}/samtools-1.20/samtools"
ENV PICARD="${TOOLS}/picard-3.1.1/picard.jar"
ENV MULTIQC="${TOOLS}/venv/bin/multiqc"

CMD ["bash"]