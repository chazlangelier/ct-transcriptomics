#!/bin/bash

mkdir -p /scratch
chmod a=rwx /scratch

aws s3 sync s3://jackkamm/ct-transcriptomics/ /scratch/ --exclude '*' \
    --include 'star_genomeGenerate_grch38*' \
    --include 'GCF_000068585.1_ASM6858v1_genomic.fna*' \
    --include GCF_000068585.1_ASM6858v1_genomic.gff

echo '* soft nofile 1000000' >> /etc/security/limits.d/20-nfile.conf
echo '* hard nofile 1000000' >> /etc/security/limits.d/20-nfile.conf
