#!/bin/bash

#************************************** Log Sync & Delete************************************************

####Sync the file to S3 bucket from the private server
aws s3 sync /home/ec2-user/scripts/logs s3://lsegvpc >/dev/null 2>&1

####Deleting the file from the private server after syncing to the S3 bucket
name=$(aws s3 ls s3://lsegvpc | grep $today.tar.gz | awk '{print$4}')

if [ "${name}" == "$today.tar.gz" ]
then
echo "Log Uploaded Successfully"
sudo rm /home/ec2-user/scripts/logs/$today.tar.gz
else
echo "Error Uploading"
fi
