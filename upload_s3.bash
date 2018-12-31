#!/bin/bash
set -ex

aws s3 sync scratch/ s3://jackkamm/ct-transcriptomics/ --exclude '*' \
    --include GCF_000068585.1_ASM6858v1_genomic.fna \
    --include GCF_000068585.1_ASM6858v1_genomic.gff \
    --include '*.featureCounts' \
    --include '*.featureCounts.summary' \
    --include OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191.bam \
    --include test_STAR_Unmapped.bam \
    --include OPS016_CT_Transcriptome_RNA_8hpi-2a_O9_S203.bam
