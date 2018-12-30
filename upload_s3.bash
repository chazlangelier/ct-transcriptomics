#!/bin/bash
set -e
set -x

# TODO can't comment out lines, find a better way to avoid re-uploading here
for fname in \
    GCF_000068585.1_ASM6858v1_genomic.fna GCF_000068585.1_ASM6858v1_genomic.gff \
    OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191.bam \
    OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191.featureCounts \
    OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191.featureCounts.summary; do
    aws s3 cp scratch/$fname s3://jackkamm/ct-transcriptomics/$fname
done
