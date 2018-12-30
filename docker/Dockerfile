FROM continuumio/miniconda3
RUN conda install -y -c bioconda -c conda-forge bwa samtools
ADD align_reads.sh /usr/local/bin/align_reads.sh
