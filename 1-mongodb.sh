#!/bin/bash

#Call common script
source ./common.sh
#Check root access
check_root_access
#Creating logs directory
logs_creation
#Configure Mongodb

cp $current_dir/mongo.repo /etc/yum.repos.d/mongo.repo
error_handler Adding_Repo_File
dnf install mongodb-org -y &>>$log
error_handler Mongodb_Installation
systemctl enable mongod &>>$log
error_handler enabling_service
systemctl start mongod &>>$log
error_handler start_the_service
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf 
error_handler binding_the_ip
systemctl restart mongod &>>$log
error_handler restarting_mongod_service
end_time