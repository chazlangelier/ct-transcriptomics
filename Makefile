# TODO: fraction of assigned alignments extremely low. Investigate in IGV
scratch/OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191.featureCounts:
	docker-compose run --rm subread \
	 featureCounts \
	 -T 32 \
	 -p \
	 -t gene \
	 -g Name \
	 -a /scratch/GCF_000068585.1_ASM6858v1_genomic.gff \
	 -o /scratch/$(@F) /scratch/OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191.bam

# TODO trimmomatic?
scratch/OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191.bam:
scratch/%.bam:
	docker-compose run --rm ct-transcriptomics \
	 align_reads.sh /scratch/GCF_000068585.1_ASM6858v1_genomic.fna \
	 /scratch/$* /scratch/$(@F) 70 3

scratch/GCF_000068585.1_ASM6858v1_genomic.fna.bwt:
	docker-compose run --rm bwa \
	 bwa index /scratch/GCF_000068585.1_ASM6858v1_genomic.fna

scratch/GCF_000068585.1_ASM6858v1_genomic.1.bt2:
	docker-compose run --rm bowtie2 \
	 bowtie2-build --threads 70 scratch/GCF_000068585.1_ASM6858v1_genomic.fna scratch/GCF_000068585.1_ASM6858v1_genomic

scratch/OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191_R1_001.fastq.gz:
scratch/OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191_R2_001.fastq.gz:
scratch/OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191_R%_001.fastq.gz:
	scp ubuntu@ec2-52-11-255-137.us-west-2.compute.amazonaws.com:/mnt/data/ct-transcriptomics/$(@F) $@

scratch/GCF_000068585.1_ASM6858v1_genomic.gff:
scratch/GCF_000068585.1_ASM6858v1_genomic.gtf:
scratch/GCF_000068585.1_ASM6858v1_genomic.fna:
scratch/GCF_000068585.1_ASM6858v1_genomic.%:
	scp ubuntu@ec2-52-11-255-137.us-west-2.compute.amazonaws.com:/mnt/data/ct-transcriptomics/$(@F) $@
