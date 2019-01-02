import json
import boto3

batch_client = boto3.client("batch")

with open("logs/job_definition.json") as f:
    jobDefinition = json.load(f)["jobDefinitionArn"]

with open("logs/job_queue.json") as f:
    jobQueue = json.load(f)["jobQueueArn"]

response = batch_client.submit_job(
    jobName="jackkamm-ct-transcriptomics-test",
    jobQueue=jobQueue,
    jobDefinition=jobDefinition,
    parameters={
        "out_prefix": "s3://jackkamm/ct-transcriptomics/submit_test_job/test",
        "s3_fq_1": "s3://czb-seqbot/fastqs/181214_A00111_0242_AHG5HKDSXX/rawdata/Paula_HayakawaSerpa_OPS016/OPS016_CT_Transcriptome_RNA_8hpi-2a_O9_S203_R1_001.fastq.gz",
        "s3_fq_2": "s3://czb-seqbot/fastqs/181214_A00111_0242_AHG5HKDSXX/rawdata/Paula_HayakawaSerpa_OPS016/OPS016_CT_Transcriptome_RNA_8hpi-2a_O9_S203_R2_001.fastq.gz",
    }
)

with open("logs/test_job.json", "w") as f:
    json.dump(response, f, indent=4, default=str)
