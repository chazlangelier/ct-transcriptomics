#!/usr/bin/env python3

import argparse
import os
import shutil
import shlex
import tempfile
import logging
import subprocess

logging.basicConfig(level=logging.INFO, format='%(asctime)s %(message)s')

def run(cmd, **kwargs):
    logging.info(cmd)
    subprocess.run(cmd, check=True, **kwargs)

parser = argparse.ArgumentParser()
parser.add_argument("out_prefix")
parser.add_argument("s3_fq_1")
parser.add_argument("s3_fq_2")
parser.add_argument("--threads", default=15, type=int)
parser.add_argument("--workdir", default=None)

args = parser.parse_args()

s3_dir = os.path.dirname(args.out_prefix)
basename_prefix = os.path.basename(args.out_prefix)

workdir = args.workdir
use_tmp_workdir = not workdir
if use_tmp_workdir:
    workdir = tempfile.mkdtemp(dir=".")

try:
    fq_1 = os.path.join(workdir, os.path.basename(args.s3_fq_1))
    fq_2 = os.path.join(workdir, os.path.basename(args.s3_fq_2))

    run(["aws", "s3", "cp", args.s3_fq_1, fq_1])
    run(["aws", "s3", "cp", args.s3_fq_2, fq_2])

    star_out_prefix = os.path.join(workdir, basename_prefix + ".star_")
    star_cmd = [
        "STAR",
        "--runThreadN", str(args.threads),
        "--genomeDir", "star_genomeGenerate_grch38",
        "--readFilesIn", fq_1, fq_2,
        "--readFilesCommand", "zcat",
        "--outSAMtype", "None",
        "--quantMode", "GeneCounts",
        "--outFileNamePrefix", star_out_prefix,
        "--outReadsUnmapped", "Fastx"
    ]
    run(star_cmd)

    unmapped_fq = star_out_prefix + "Unmapped.out.mate{}"
    bwa_out = star_out_prefix + "Unmapped.bwa_mem.bam"
    bwa_cmd = [
        "bwa", "mem",
        "-t", shlex.quote(str(args.threads)),
        "GCF_000068585.1_ASM6858v1_genomic.fna",
        shlex.quote(unmapped_fq.format(1)),
        shlex.quote(unmapped_fq.format(2)),
        "|",
        "samtools", "sort", "-@", shlex.quote(str(args.threads)),
        "-o", shlex.quote(bwa_out), "-"
    ]
    run(" ".join(bwa_cmd), shell=True)

    subread_out = bwa_out + ".featureCounts"
    subread_cmd = [
        "featureCounts",
        "-T", str(min(32, args.threads)),
        "-p",
        "-t", "gene",
        "-g", "Name",
        "-a", "GCF_000068585.1_ASM6858v1_genomic.gff",
        "-o", subread_out,
        bwa_out
    ]
    run(subread_cmd)

    upload_files = [
        star_out_prefix + "ReadsPerGene.out.tab",
        bwa_out,
        subread_out,
        subread_out + ".summary"
    ]
    for fname in upload_files:
        run([
            "aws", "s3", "cp", fname,
            os.path.join(s3_dir, os.path.basename(fname))
        ])
except:
    raise
finally:
    if use_tmp_workdir:
        shutil.rmtree(workdir)
