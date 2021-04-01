#!/bin/bash

#******************************** Log Collector *********************************

today=$(date +"%d_%m_%Y_%H.%M.%S")
mkdir -p /home/ec2-user/$today

####Capture the web content to a file
wget -O /tmp/web_content/$today 52.44.102.170 >/dev/null 2>&1

####Copy web content file and httpd logs a directory above made
sudo cp /tmp/web_content/$today /home/ec2-user/$today
sudo cp /var/log/httpd/access_log /home/ec2-user/$today
sudo cp /var/log/httpd/error_log /home/ec2-user/$today

####Compress and zip the directory containing web content file and logs
cd /home/ec2-user
tar -czf /home/ec2-user/$today.tar.gz $today >/dev/null 2>&1

###Copy the zipped content to the private server
scp -rp -i privateKey.pem $today.tar.gz ec2-user@10.0.2.227:/home/ec2-user/scripts/logs

####Executing the file sync to S3 bucket and delete the file from the private directory
ssh  -i privateKey.pem ec2-user@10.0.2.227 "today=$today /home/ec2-user/scripts/log.sync.sh"

