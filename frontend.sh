#!/bin/bash

USER=$(id -u)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1 )
TIME_STAMP=$(date +%F-%H-%M-%S)
LOG_FILE=/tmp/$SCRIPT_NAME-$TIME_STAMP.log 
echo "log file name is $LOG_FILE"


R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USER -eq 0 ]
then    
    echo -e  "$G you are super user $N "
else 
    echo -e " $R  you are not super user $N"
    exit 1 
fi 

VALIDATION_FUNCTION(){
    if [ $1 -eq 0 ]
    then
        echo -e  " $G succfully ... $2 $N"
    else
        echo -e  " $R failure  ... $2 $N"
        exit 1
    fi 
}

dnf install nginx -y &>>$LOG_FILE
VALIDATION_FUNCTION $? "install nginx "

systemctl enable nginx &>>$LOG_FILE
VALIDATION_FUNCTION $? "enabling  nginx "
systemctl start nginx &>>$LOG_FILE
VALIDATION_FUNCTION $? "starting  nginx "
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
VALIDATION_FUNCTION $? "removing the default content  "

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOG_FILE
VALIDATION_FUNCTION $? "downlode the frontend code "

cd /usr/share/nginx/html/
unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATION_FUNCTION $? "install nginx "
cp /home/ec2-user/expense_shell/frontend.conf /etc/nginx/default.d/expense.conf &>>$LOG_FILE
VALIDATION_FUNCTION $? "copying the expense.conf "
systemctl restart nginx &>>$LOG_FILE
VALIDATION_FUNCTION $? "restart nginx "
