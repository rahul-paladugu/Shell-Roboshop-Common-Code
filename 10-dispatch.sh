#!/bin/bash

#Call common script
source ./common.sh
#Check root access
check_root_access
#Creating logs directory
logs_creation
#Configure Dispatch
start_time
dnf install golang -y -y &>>$log
error_handler Installing_golang
system_user
error_handler Creating_system_user
download_code dispatch
error_handler Download_dispatch_code
go mod init dispatch &>>$log
error_handler Dependencies_go_mod
go get &>>$log
error_handler Dependencies_go_get
go build &>>$log
error_handler Dependencies_go_build
#Setup Dispatch Service
cp $script_dir/dispatch.service /etc/systemd/system/dispatch.service
error_handler Downloading_dispatch_service
start_enable_service dispatch
end_time Dispatch
