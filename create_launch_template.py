import sys
import base64
import json
import boto3

user_data = """#!/bin/bash
mkdir -p /scratch
chmod a=rwx /scratch

aws s3 sync s3://jackkamm/ct-transcriptomics/ /scratch/ --exclude '*' \
    --include 'star_genomeGenerate_grch38*' \
    --include 'GCF_000068585.1_ASM6858v1_genomic.fna*' \
    --include GCF_000068585.1_ASM6858v1_genomic.gff

echo '* soft nofile 1000000' >> /etc/security/limits.d/20-nfile.conf
echo '* hard nofile 1000000' >> /etc/security/limits.d/20-nfile.conf
"""

client = boto3.client("ec2")
response = client.create_launch_template(
    LaunchTemplateName="jackkamm-ct-transcriptomics-template",
    LaunchTemplateData={
        "BlockDeviceMappings": [
            {
                "DeviceName": "/dev/xvda",
                "Ebs": {
                    "DeleteOnTermination": True,
                    "VolumeSize": 2000,
                    "VolumeType": "gp2"
                }
            }
        ],
        'UserData': base64.b64encode(user_data.encode()).decode("ascii"),
    }
)

json.dump(response, sys.stdout, default=str, indent=4)
