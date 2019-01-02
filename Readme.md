# ct-transcriptomics

## Pipeline description

See [docker/count_genes.py](docker/count_genes.py) for the pipeline.
In summary:

0. Use STAR to map reads to human reference, obtain host gene expression, and filter out the host reads.
0. Use bwa-mem to map the non-host reads to CT reference genome.
0. Use featureCounts to count genes in CT alignment.

## Output files

Output files are in `s3://jackkamm/ct-transcriptomics/gene_counts/`.
The files are:

0. `{sample}.star_ReadsPerGene.out.tab`: Host gene expression output by STAR.
0. `{sample}.star_Unmapped.bwa_mem.bam`: CT alignment output by bwa-mem.
0. `{sample}.star_Unmapped.bwa_mem.bam.featureCounts`: CT gene expression output by featureCounts.
0. `{sample}.star_Unmapped.bwa_mem.bam.featureCounts.summary`: Summary statistics output by featureCounts.
