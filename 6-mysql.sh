#!/bin/bash

#Call common script
source ./common.sh
#Check root access
check_root_access
#Creating logs directory
logs_creation
#Configure Mysql
start_time
dnf install mysql-server -y &>>$log
error_handler Instally_mysql_server
start_enable_service mysqld
error_handler Start_mysqld_service
mysql_secure_installation --set-root-pass RoboShop@1 &>>$log
error_handler Set_root_password
end_time Mysql