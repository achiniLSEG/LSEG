#!/bin/bash

#***********************************************httpd Status Check************************************************************

time_stamp=$(date +"%d_%m_%Y_%H.%M.%S")

####Check the httpd status, start the service if not running
status=$(systemctl status httpd | grep Active | awk '{ print $2 }')

if [ "${status}" == "active" ]
then
echo "Apache Server is ACTIVE(running)"
else
   sudo systemctl start httpd
echo "Apache Server Started"
fi

####Check the status of the website and insert the values to the SQL DB
site=$(curl -I http://52.44.102.170 2>&1 | grep HTTP | awk '{print$2}')

if [ "${site}" == "200" ]
then
        echo "Website up & Running"
mysql -h lesgtest-rds.czptvqzzxg9c.us-east-1.rds.amazonaws.com -P 3306 --user=admin --password=mysqldb2021 -e "use ServercontentDB;INSERT INTO Status_details(timestamp , serverstatus, webstatus) VALUES ('$time_stamp' , '$status', '$site');select * from Status_details;" >>/dev/null 2>&1
else
	echo "Website Not Working"
	echo "Sending Mail"
	aws ses send-email --from madushani.hda@gmail.com --to madushani.hda@gmail.com --subject "Alert" --text "Error loading the Website" >>/dev/null 2>&1
fi

