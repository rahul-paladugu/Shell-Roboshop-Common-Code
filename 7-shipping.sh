#!/bin/bash

#Call common script
source ./common.sh
#Check root access
check_root_access
#Creating logs directory
logs_creation
#Configure Shipping
start_time
dnf install maven -y &>>$log
error_handler Installing_maven
system_user
error_handler Creating_system_user
download_code shipping
error_handler Downloading_code
mvn clean package &>>$log
error_handler Installing_dependencies
mv target/shipping-1.0.jar shipping.jar &>>$log
error_handler Loading_packages
#Setup shipping service
cp $script_dir/shipping.service /etc/systemd/system/shipping.service
error_handler Downloading_service_config
systemctl daemon-reload &>>$log
error_handler Daemon_reload
start_enable_service shipping
error_handler Start_shipping_service
#Configuring SQL & loading schemas
dnf install mysql -y &>>$log
error_handler Installing_sql
mysql -h mysql.rscloudservices.icu -uroot -pRoboShop@1 < /app/db/schema.sql &>>$log
mysql -h mysql.rscloudservices.icu -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$log
mysql -h mysql.rscloudservices.icu -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$log
error_handler Loading_schemas
systemctl restart shipping &>>$log
error_handler Restart_shipping_service
end_time Shipping