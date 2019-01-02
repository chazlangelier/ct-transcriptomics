FROM continuumio/miniconda3
# bioconda version of STAR not yet patched for bug https://github.com/alexdobin/STAR/issues/222
RUN cd /root && \
        wget https://github.com/alexdobin/STAR/archive/2.6.1d.tar.gz && \
        tar -xvf 2.6.1d.tar.gz && \
        cp STAR-2.6.1d/bin/Linux_x86_64_static/STAR /usr/local/bin/
RUN conda install -y -c bioconda -c conda-forge bwa samtools subread
RUN pip install awscli
ADD count_genes.py /usr/local/bin/count_genes.py
WORKDIR /scratch
