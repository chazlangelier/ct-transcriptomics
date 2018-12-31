#!/bin/bash
set -x
set -e
set -o pipefail

REF=$1
QUERY1=$2
QUERY2=$3
OUT=$4
BWA_THREADS=$5
SAMTOOLS_THREADS=$6

bwa mem -t $BWA_THREADS $REF $QUERY1 $QUERY2 |
    samtools sort -@ $SAMTOOLS_THREADS -o $OUT -
