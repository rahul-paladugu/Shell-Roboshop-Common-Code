#!/bin/bash

#Call common script
source ./common.sh
#Check root access
check_root_access
#Creating logs directory
logs_creation
#Configure user
start_time
dnf module disable nodejs -y &>>$log
error_handler Disabling_default_nodejs
dnf module enable nodejs:20 -y &>>$log
error_handler Enabling_nodejs_20
dnf install nodejs -y &>>$log
error_handler Installing_nodejs_20_version
system_user
error_handler Creating_system_user
Downloading_code user
error_handler Downloading_user_code
npm install &>>$log
error_handler Installing_dependencies
#User service setup
cp $script_dir/user.service /etc/systemd/system/user.service
systemctl daemon-reload &>>$log
error_handler Daemon_reload
start_enable_service user
error_handler Start_user_service
end_time