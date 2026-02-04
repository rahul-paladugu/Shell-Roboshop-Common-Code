#!/bin/bash

#Call common script
source ./common.sh
#Check root access
check_root_access
#Creating logs directory
logs_creation
#Configure Rabbitmq
cp $script_dir/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
error_handler Copying_rabbitmq_repo
dnf install rabbitmq-server -y &>>$log
error_handler Installing_rabbitmq_server
start_enable_service rabbitmq-server
error_handler Start_rabbitmq_service
rabbitmqctl add_user roboshop roboshop123 &>>$log
error_handler Adding_db_user
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log
error_handler Setting_permissions_to_db_user
end_time Rabbitmq