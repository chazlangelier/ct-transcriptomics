scratch/OPS016_CT_Transcriptome_RNA_8hpi-2a_O9_S203.featureCounts:
scratch/test_STAR_Unmapped.featureCounts:
scratch/OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191.featureCounts:
scratch/%.featureCounts:
	docker-compose run --rm subread \
	 featureCounts \
	 -T 32 \
	 -p \
	 -t gene \
	 -g Name \
	 -a /scratch/GCF_000068585.1_ASM6858v1_genomic.gff \
	 -o /scratch/$(@F) /scratch/$*.bam

scratch/test_STAR_Unmapped.bam:
	docker-compose run --rm ct-transcriptomics \
	 align_reads.sh /scratch/GCF_000068585.1_ASM6858v1_genomic.fna \
	 /scratch/test_STAR_Unmapped.out.mate1 /scratch/test_STAR_Unmapped.out.mate2 \
	 /scratch/$(@F) 30 3

# NOTE: didn't utilize full CPU (maybe 15-30 cpus), but used a lot of RAM (like 40gb), and a lot of tmp disk space (300G)
# NOTE: sorting the BAM is slow and unnecessary
test_star:
	docker-compose run --rm star \
	 STAR --runThreadN 70 --genomeDir star_genomeGenerate_grch38 \
	 --readFilesIn \
	 OPS016_CT_Transcriptome_RNA_8hpi-2a_O9_S203_R1_001.fastq.gz \
	 OPS016_CT_Transcriptome_RNA_8hpi-2a_O9_S203_R2_001.fastq.gz \
	 --readFilesCommand zcat \
	 --outSAMtype BAM SortedByCoordinate \
	 --quantMode GeneCounts \
	 --outFileNamePrefix test_STAR_ \
	 --outReadsUnmapped Fastx

scratch/star_genomeGenerate_grch38:
	mkdir $@
	docker-compose run --rm star \
	 STAR --runThreadN 70 --runMode genomeGenerate --genomeDir $(@F) \
	 --genomeFastaFiles GCA_000001405.15_GRCh38_no_alt_analysis_set.fna \
	 --sjdbGTFfile GCA_000001405.15_GRCh38_full_analysis_set.refseq_annotation.gtf

scratch/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna: scratch/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz
	gunzip $<

scratch/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz:
	cd scratch && wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz

scratch/GCA_000001405.15_GRCh38_full_analysis_set.refseq_annotation.gtf: scratch/GCA_000001405.15_GRCh38_full_analysis_set.refseq_annotation.gff.gz
	zcat $< | gffread -E - -T -o- > $@

scratch/GCA_000001405.15_GRCh38_full_analysis_set.refseq_annotation.gff.gz:
	cd scratch && wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids/GCA_000001405.15_GRCh38_full_analysis_set.refseq_annotation.gff.gz

scratch/OPS016_CT_Transcriptome_RNA_8hpi-2a_O9_S203.bam:
scratch/OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191.bam:
scratch/%.bam:
	docker-compose run --rm ct-transcriptomics \
	 align_reads.sh /scratch/GCF_000068585.1_ASM6858v1_genomic.fna \
	 /scratch/$*_R1_001.fastq.gz /scratch/$*_R2_001.fastq.gz \
	 /scratch/$(@F) 30 3

scratch/GCF_000068585.1_ASM6858v1_genomic.fna.bwt:
	docker-compose run --rm bwa \
	 bwa index /scratch/GCF_000068585.1_ASM6858v1_genomic.fna

scratch/GCF_000068585.1_ASM6858v1_genomic.1.bt2:
	docker-compose run --rm bowtie2 \
	 bowtie2-build --threads 70 scratch/GCF_000068585.1_ASM6858v1_genomic.fna scratch/GCF_000068585.1_ASM6858v1_genomic

scratch/OPS016_CT_Transcriptome_RNA_8hpi-2a_O9_S203_R1_001.fastq.gz:
scratch/OPS016_CT_Transcriptome_RNA_8hpi-2a_O9_S203_R2_001.fastq.gz:
scratch/OPS016_CT_Transcriptome_RNA_24hpi-3b_O7_S202_R1_001.fastq.gz:
scratch/OPS016_CT_Transcriptome_RNA_24hpi-3b_O7_S202_R2_001.fastq.gz:
scratch/OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191_R1_001.fastq.gz:
scratch/OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191_R2_001.fastq.gz:
scratch/OPS016_CT_Transcriptome_RNA_%_001.fastq.gz:
	aws s3 cp s3://czb-seqbot/fastqs/181214_A00111_0242_AHG5HKDSXX/rawdata/Paula_HayakawaSerpa_OPS016/$(@F) $@

scratch/GCF_000068585.1_ASM6858v1_genomic.gff:
scratch/GCF_000068585.1_ASM6858v1_genomic.gtf:
scratch/GCF_000068585.1_ASM6858v1_genomic.fna:
scratch/GCF_000068585.1_ASM6858v1_genomic.%:
	scp ubuntu@ec2-52-11-255-137.us-west-2.compute.amazonaws.com:/mnt/data/ct-transcriptomics/$(@F) $@
