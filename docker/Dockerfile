FROM continuumio/miniconda3
RUN conda install -y -c bioconda -c conda-forge bwa samtools star subread
RUN pip install awscli
ADD count_genes.py /usr/local/bin/count_genes.py
