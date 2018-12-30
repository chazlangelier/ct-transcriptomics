#NOTE STAR manual says: In general, for --sjdbGTFfile files STAR only processes lines which have --sjdbGTFfeatureExon (=exon by default) in the 3rd field (column).
#HOWEVER bacteria don't have exons right?? should we use gene features instead?
# We probably shouldn't even use STAR to begin with...
test_STAR:
	STAR --runThreadN 70 --genomeDir ./CT-STAR-index/ --alignIntronMax 1 --readFilesIn OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191_R1_001.fastq.gz OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191_R2_001.fastq.gz --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --outFileNamePrefix test_STAR_

# See https://groups.google.com/forum/#!topic/rna-star/w4-K7OKd7yM
# for why we need "--sjdbGTFtagExonParentGene gene_name"
# NOTE (do we also need this option for mapping?)
CT-STAR-index:
	mkdir $@
#	STAR --runThreadN 70 --runMode genomeGenerate --genomeDir $@ --genomeFastaFiles GCF_000068585.1_ASM6858v1_genomic.fna --sjdbGTFfile GCF_000068585.1_ASM6858v1_genomic.gff --genomeSAindexNbases 9 --sjdbGTFtagExonParentTranscript Parent
	STAR --runThreadN 70 --runMode genomeGenerate --genomeDir $@ --genomeFastaFiles GCF_000068585.1_ASM6858v1_genomic.fna --sjdbGTFfile GCF_000068585.1_ASM6858v1_genomic.gtf --genomeSAindexNbases 9
#	STAR --runThreadN 70 --runMode genomeGenerate --genomeDir $@ --genomeFastaFiles GCF_000068585.1_ASM6858v1_genomic.fna --sjdbGTFfile GCF_000068585.1_ASM6858v1_genomic.gtf --genomeSAindexNbases 9 --sjdbGTFtagExonParentGene gene_name

OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191_R1_001.fastq.gz:
OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191_R2_001.fastq.gz:
OPS016_CT_Transcriptome_RNA_8hpi-1a_I9_S191_R%_001.fastq.gz:
	scp ubuntu@ec2-52-11-255-137.us-west-2.compute.amazonaws.com:/mnt/data/ct-transcriptomics/$@ $@

GCF_000068585.1_ASM6858v1_genomic.gff:
GCF_000068585.1_ASM6858v1_genomic.gtf:
GCF_000068585.1_ASM6858v1_genomic.fna:
GCF_000068585.1_ASM6858v1_genomic.%:
	scp ubuntu@ec2-52-11-255-137.us-west-2.compute.amazonaws.com:/mnt/data/ct-transcriptomics/$@ $@
