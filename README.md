# expense_shell

# trouble shooting 
# Mysql 
ps -ef | grep 3306 
netstat -lntp | grep mysql 
Also 
check we are able to login the mysql server 

mysql -h db.78skedar.online -uroot -pExpenseApp@1 -e 'SHOW DATABASES'

# backend 
ps -ef | grep 8080
netstat -lntp | grep backend 
to check the backend is connted sccessfull to db 
telnet db.78skedar.online 3306 

# frontend 

ps -ef | grep 80
netstat -lntp | grep nginx 

to check the frontend  is connted sccessfull to backend
telnet backend.78skedar.online 3306
# make sure everything is fine in .service and config files 
