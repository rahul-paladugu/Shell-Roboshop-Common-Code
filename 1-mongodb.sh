#!/bin/bash

#Call common script
source ./common.sh
#Check root access
check_root_access
#Creating logs directory
logs_creation
#Configure Mongodb
start_time
rm -rf /etc/yum.repos.d/mongo.repo
error_handler Remove_existing_repo
cp $script_dir/mongo.repo /etc/yum.repos.d/mongo.repo
error_handler Adding_Repo_File
dnf install mongodb-org -y &>>$log
error_handler Mongodb_Installation
systemctl enable mongod &>>$log
error_handler Enabling_service
systemctl start mongod &>>$log
error_handler Start_the_service
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf 
error_handler Binding_the_ip
systemctl restart mongod &>>$log
error_handler Restarting_mongod_service
end_time Mongodb