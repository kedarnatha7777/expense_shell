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

dnf module disable nodejs  -y &>>$LOG_FILE
VALIDATION_FUNCTION $? "diasbling node-js"

dnf module enable nodejs:20 -y  &>>$LOG_FILE
VALIDATION_FUNCTION $? "enabling node-js"

dnf install nodejs -y  &>>$LOG_FILE
VALIDATION_FUNCTION $? "install  node-js"

# useradd expense &>>$LOG_FILE
# VALIDATION_FUNCTION $? "creating expense user "

id expense &>>$LOG_FILE
 if [ $? -eq 0 ]
    then
        echo  "expense user already existed "
    else
       echo  "expense user not existed "
       useradd expense &>>$LOG_FILE
    fi

mkdir -p /app &>>$LOG_FILE
VALIDATION_FUNCTION $? "creating app dir"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOG_FILE
VALIDATION_FUNCTION $? "downlode backend"

cd /app
rm -rf /app/* 
unzip /tmp/backend.zip &>>$LOG_FILE
VALIDATION_FUNCTION $? "unzip the backend"

npm install &>>$LOG_FILE
VALIDATION_FUNCTION  $? "downlode the dependencies"

cp /home/ec2-user/expense_shell/backend.service /etc/systemd/system/backend.service &>>$LOG_FILE
VALIDATION_FUNCTION  $? "copying the backend service"

systemctl daemon-reload &>>$LOG_FILE
VALIDATION_FUNCTION  $? "daemon -reload "

systemctl start backend &>>$LOG_FILE
VALIDATION_FUNCTION  $? "starting backend "
systemctl enable backend &>>$LOG_FILE
VALIDATION_FUNCTION  $? "enable backend "

dnf install mysql -y &>>$LOG_FILE
VALIDATION_FUNCTION  $? "installong mysql clint "

mysql -h db.78skedar.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$LOG_FILE
VALIDATION_FUNCTION  $? "schema loading"

systemctl restart backend &>>$LOG_FILE
VALIDATION_FUNCTION  $? "restarting backed"