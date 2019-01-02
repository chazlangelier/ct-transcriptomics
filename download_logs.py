import os
import json
import boto3

logs_client = boto3.client("logs")
batch_client = boto3.client("batch")

dired = "logs/jobs"
job_ids = {}
for fname in os.listdir(dired):
    with open(os.path.join(dired, fname)) as f:
        job_info = json.load(f)
        job_ids[job_info["jobName"]] = job_info["jobId"]

for job_name, job_id in job_ids.items():
    with open(os.path.join("scratch/job_logs", job_name + ".json"), "w") as f:
        job_info, = batch_client.describe_jobs(
            jobs=[job_id])["jobs"]
        attempt, = job_info["attempts"]
        log_stream_name = attempt["container"]["logStreamName"]
        json.dump(
            logs_client.get_log_events(
                logGroupName="/aws/batch/job",
                logStreamName=log_stream_name),
            f, indent=4
        )
