#!/bin/bash
set -ex

aws s3 sync scratch/ s3://jackkamm/ct-transcriptomics/ --exclude '*' \
    --include 'star_genomeGenerate_grch38*' \
    --include 'GCF_000068585.1_ASM6858v1_genomic.fna*' \
    --include GCF_000068585.1_ASM6858v1_genomic.gff
