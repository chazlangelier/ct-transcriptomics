# ct-transcriptomics

## Pipeline description

See [docker/count_genes.py](docker/count_genes.py) for the pipeline.
In summary:

0. Use STAR to map reads to human reference, obtain host gene expression, and filter out the host reads.
0. Use bwa-mem to map the non-host reads to CT (chlamydia trachomatis) reference genome.
0. Use featureCounts to count genes in CT alignment.

## Output files

Output files are in `s3://jackkamm/ct-transcriptomics/gene_counts/`.
The files are:

0. `{sample}.star_ReadsPerGene.out.tab`: Host gene expression output by STAR.
0. `{sample}.star_Unmapped.bwa_mem.bam`: CT alignment output by bwa-mem.
0. `{sample}.star_Unmapped.bwa_mem.bam.featureCounts`: CT gene expression output by featureCounts.
0. `{sample}.star_Unmapped.bwa_mem.bam.featureCounts.summary`: Summary statistics output by featureCounts.

## AWS batch notes

- Setup the cluster with `python setup_aws_batch.py`
  - All jobs required the same STAR index, which is a large file, so I downloaded a copy to be shared across all jobs (via the Launch Template), rather than downloading a separate copy for each job. Note this considerably increased the instance startup time -- consider using s3mi in the future.
- Submit jobs to the cluster with `python submit_jobs.py`

Don't forget to clean up the cluster afterwards! I did this with the AWS Web console interface.
