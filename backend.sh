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
       useradd expense 
    fi

