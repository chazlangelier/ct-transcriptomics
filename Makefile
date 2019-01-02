submit_test_job:
	python submit_test_job.py

setup_aws_batch:
	mkdir -p logs
	python setup_aws_batch.py

# used about 30G RAM, 20G disk
scratch/test_count_genes:
	mkdir -p $@
	docker-compose run --rm ct-transcriptomics \
	 count_genes.py \
	 s3://jackkamm/ct-transcriptomics/test_count_genes \
	 s3://czb-seqbot/fastqs/181214_A00111_0242_AHG5HKDSXX/rawdata/Paula_HayakawaSerpa_OPS016/OPS016_CT_Transcriptome_RNA_8hpi-2a_O9_S203_R1_001.fastq.gz \
	 s3://czb-seqbot/fastqs/181214_A00111_0242_AHG5HKDSXX/rawdata/Paula_HayakawaSerpa_OPS016/OPS016_CT_Transcriptome_RNA_8hpi-2a_O9_S203_R2_001.fastq.gz \
	 --threads 15 \
	 --workdir $(@F)

scratch/star_genomeGenerate_grch38:
	mkdir $@
	docker-compose run --rm ct-transcriptomics \
	 STAR --runThreadN 70 --runMode genomeGenerate --genomeDir $(@F) \
	 --genomeFastaFiles GRCh38.primary_assembly.genome.fa \
	 --sjdbGTFfile gencode.v29.primary_assembly.annotation.gtf

scratch/GRCh38.primary_assembly.genome.fa:
	cd $(@D) && wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_29/GRCh38.primary_assembly.genome.fa.gz
	gunzip $@.gz

scratch/gencode.v29.primary_assembly.annotation.gtf:
	cd $(@D) && wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_29/gencode.v29.primary_assembly.annotation.gtf.gz
	gunzip $@.gz

scratch/GCF_000068585.1_ASM6858v1_genomic.fna.bwt:
	docker-compose run --rm ct-transcriptomics \
	 bwa index /scratch/GCF_000068585.1_ASM6858v1_genomic.fna

scratch/GCF_000068585.1_ASM6858v1_genomic.gff:
scratch/GCF_000068585.1_ASM6858v1_genomic.fna:
scratch/GCF_000068585.1_ASM6858v1_genomic.%:
	scp ubuntu@ec2-52-11-255-137.us-west-2.compute.amazonaws.com:/mnt/data/ct-transcriptomics/$(@F) $@
