#!/bin/bash

#Call common script
source ./common.sh
#Variables for instance
ami="ami-0220d79f3f480ecf5"
sg="sg-03b441e0ba008f925"
zone="Z0711084A6IKM873A3LI"
record="rscloudservices.icu"
region="us-east-1"

instances="mongodb catalogue redis user cart mysql shipping rabbitmq payment dispatch frontend"

#Logs creation
logs_path="/var/logs/shell-roboshop/"
script_name=$(echo "$0" | cut -d "." -f1)
log="$logs_path/$script_name.log"


error_validation(){
    if [ $? -ne 0 ]; then
      echo "Error performing $1. Please review the logs"
      exit 1
    else
      echo "successfully implemented $1"
    fi
}

for instance in $instances
do
 start_time=$(date +%s)
 echo -e "${yellow}Creating AWS instance $instance as requested${reset}"
#Creating an instance and collecting instance_ID into a variable
 instance_id=$(aws ec2 run-instances --image-id $ami --instance-type t3.micro  --security-group-ids $sg  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query 'Instances[0].InstanceId' --output text)
 end_time=$(date +%s)
 echo -e "${yellow}$instance instance is created successfully${reset}"
 echo -e "${blue}Time taken to create instance is $(($end_time - $start_time))Seconds.${reset}"
# Wait until instance is running
aws ec2 wait instance-running --region "$region" --instance-ids "$instance_id"
#selecting IP address based on instance component
 if [ $instance = frontend ]; then
  ip=$(aws ec2 describe-instances --region us-east-1 --filters "Name=instance-id,Values=$instance_id" --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)
  record_name=$record &>>$log
 else
  ip=$(aws ec2 describe-instances --region us-east-1 --filters "Name=instance-id,Values=$instance_id" --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text)
  record_name="$instance.$record" &>>$log
 fi
echo -e "${yellow}ip for $instance is $ip ${reset}"
sleep 5
#Creating R53 records for the instance created above
 aws route53 change-resource-record-sets --hosted-zone-id "$zone" --change-batch ' {
    "Comment": "Create or Update A record via script",
    "Changes": [
        {
            "Action": "UPSERT",
            "ResourceRecordSet": {
                "Name": "'$record_name'",
                "Type": "A",
                "TTL": 1,
                "ResourceRecords": [
                    {
                        "Value": "'$ip'"
                    }
                ]
            }
        }
    ]
}
' &>>$log
error_validation r53_records
echo -e "${yellow}The r53 record for $instance is $instance.$record${reset}"
done

