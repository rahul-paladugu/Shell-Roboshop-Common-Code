#!/bin/bash

#Call common script
source ./common.sh
#Check root access
check_root_access
#Creating logs directory
logs_creation
#Configure Nginx
start_time
dnf module disable nginx -y &>>$log
error_handler Disabling_default_nginx
dnf module enable nginx:1.24 -y &>>$log
error_handler Enabling_nginx_1.24_version
dnf install nginx -y &>>$log
error_handler Installing_nginx
start_enable_service nginx
error_handler Start_nginx_service
rm -rf /usr/share/nginx/html/* 
error_handler Removing_nginx_default_config
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$log
error_handler Download_frontend_code
cd /usr/share/nginx/html 
error_handler Pointing_nginx_directory
unzip /tmp/frontend.zip &>>$log
error_handler Unzipping_code
#Setup Nginx service
cp $script_dir/nginx.service /etc/nginx/nginx.conf
error_handler Copying_nginx_new_service_config
systemctl restart nginx
error_handler Restarting_nginx_service
end_time Nginx