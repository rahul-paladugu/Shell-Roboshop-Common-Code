#!/bin/bash

red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
reset="\e[0m"
user=$(id -u)
current_dir=$PWD

#Checking if user using root access.
check_root_access () {
  if [ $user -ne 0 ]; then
    echo -e "$red Please run the script using root access. $reset"
    exit 1
  fi
}
#Validating errors for every task.
error_handler () {
  if [ $? -ne 0 ]; then
    echo -e "$red $1 is failed. Please review the logs. $reset"
    exit 1
  else
    echo -e "$1 is $green success. $reset"
  fi
}

#Creating Logs Folder to store the results
logs_creation () {
  logs_folder="/var/logs/shell-roboshop"
   mkdir -p $logs_folder
   script_name=$(echo $0 | cut -d "." -f1)
   log="$logs_folder/$script_name.log"
}
start_time () {
    start_time=$(date +%s)
    echo "$yellow Started executing the script at $start_time. $reset"
}
end_time (){
    end_time=$(date +%s)
    echo -e "$yellow Catalogue configuration is completed. Time taken in $(($end_time - $start_time)) Seconds. $reset"

}
download_code () {
echo -e "$yellow Creating App directory $reset"
mkdir -p /app 
echo -e "$yellow Downloading and unzipping code $reset"
curl -L -o /tmp/$1.zip https://roboshop-artifacts.s3.amazonaws.com/$1-v3.zip
rm -rf /app/*
cd /app 
unzip /tmp/$1.zip
cd /app 
}