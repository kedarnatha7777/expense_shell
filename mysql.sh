#!/bin/bash 

USER=$(id -u)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1 )
TIME_STAMP=$(date +%F-%H-%M-%S)
LOG_FILE=/tmp/$SCRIPT_NAME-$TIME_STAMP.log 
echo "log file name is $LOG_FILE"
echo "please enter the mysql root password"
read db_password
echo $db_password

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USER -eq 0 ]
then
    echo -e  "$G you are super user $N "
else 
    echo -e "$R you are not super user $N "
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

dnf install mysql-server -y &>>$LOG_FILE
VALIDATION_FUNCTION $? "installing mysql-server"

systemctl enable mysqld &>>$LOG_FILE
VALIDATION_FUNCTION $? "enabling mysqld"

systemctl start mysqld &>>$LOG_FILE
VALIDATION_FUNCTION $? "starting  mysqld"

mysql -h db.78skedar.online -uroot -p${db_password} -e 'SHOW DATABASES' &>>$LOG_FILE
if [ $? -eq 0 ]
    then
        echo "mysql root password is already setuped "
    else
        echo -e  "mysql root password is not setuped "
        mysql_secure_installation --set-uroot-pass ${db_password}  &>>$LOG_FILE
    fi 



