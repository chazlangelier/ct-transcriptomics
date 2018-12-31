#!/bin/bash
set -ex

aws s3 sync scratch/ s3://jackkamm/ct-transcriptomics/ --exclude '*' \
    --include GCF_000068585.1_ASM6858v1_genomic.fna \
    --include GCF_000068585.1_ASM6858v1_genomic.gff \
    --include OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191.bam \
    --include OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191.featureCounts \
    --include OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191.featureCounts.summary
