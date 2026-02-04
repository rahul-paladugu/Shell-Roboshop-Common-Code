#!/bin/bash

#Call common script
source ./common.sh
#Check root access
check_root_access
#Creating logs directory
logs_creation
#Configure Catalogue
start_time
dnf module disable nodejs -y &>>$log
error_handler Disable_existing_nodejs
dnf module enable nodejs:20 -y &>>$log
error_handler Enabling_nodejs_20_Version
dnf install nodejs -y &>>$log
error_handler Install_nodejs
system_user
error_handler System_user_creation
download_code catalogue
error_handler Downloading_code
npm install &>>$log
error_handler Instaiing_dependencies
#Catalogue Service Setup
echo -e "${blue}Configuring catalogue service.... $reset"
cp $script_dir/catalogue.service /etc/systemd/system/catalogue.service
error_handler Service_setup
systemctl daemon-reload &>>$log
start_enable_service catalogue
error_handler Enabling_service
echo -e "${blue}Catalogue service configuration is sucess.... $reset"
#Configuring the mongodb in catalogue.
cp $script_dir/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log
error_handler Mongo_repo
dnf install mongodb-mongosh -y &>>$log
error_handler Install_mongosh
mongosh --host mongodb.rscloudservices.icu </app/db/master-data.js &>>$log
error_handler Load_mongo_schema
end_time Catalogue