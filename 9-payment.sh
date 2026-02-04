#!/bin/bash

#Call common script
source ./common.sh
#Check root access
check_root_access
#Creating logs directory
logs_creation
#Configure Payment
start_time
dnf install python3 gcc python3-devel -y &>>$log
error_handler Installing_python
system_user
error_handler Creating_system_user
download_code payment
error_handler Downloading_payment_code
pip3 install -r requirements.txt &>>$log
error_handler Installing_dependencies
#Setup Payment Service
cp $script_dir/payment.service /etc/systemd/system/payment.service
error_handler Downloading_payment_service
systemctl daemon-reload &>>$log
error_handler Daemon_reload
start_enable_service payment
error_handler Start_payment_service
end_time Payment