#!/bin/bash
set -x
set -e
set -o pipefail

REF=$1
QUERY=$2
OUT=$3
BWA_THREADS=$4
SAMTOOLS_THREADS=$5

bwa mem -t $BWA_THREADS $REF ${QUERY}_R1_001.fastq.gz ${QUERY}_R2_001.fastq.gz |
    samtools view -@ $SAMTOOLS_THREADS -b - > ${OUT}
