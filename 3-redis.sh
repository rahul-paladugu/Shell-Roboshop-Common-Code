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
#Redis Service Setup
dnf module disable redis -y &>>$log
error_handler Disable_default_redis
dnf module enable redis:7 -y &>>$log
error_handler Enable_redis_7
dnf install redis -y &>>$log
error_handler Installing_redis_version_7
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
error_handler Binding_ip
sed -i '111s/protected-mode yes/protected-mode no/' /etc/redis/redis.conf
error_handler Disabling_protected_mode
start_enable_service redis
error_handler start_and_enable_redis
end_time Redis