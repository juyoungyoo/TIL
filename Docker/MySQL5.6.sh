#!/bin/sh

# Absolute path
PATH_NAME=$(pwd)
echo $PATH_NAME

# MySQL5.6 run
docker run -d -it --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root -e MYSQL_USER=mysql -e MYSQL_PASSWORD=mysql -e MYSQL_DATABASE=kanban -e TZ=Asia/Seoul \
-v $PATH_NAME/volume/mysql/script/init.sql:/docker-entrypoint-initdb.d/init.sql \
-v $PATH_NAME/volume/mysql:/var/lib/mysql \
--health-cmd='mysqladmin -uroot -proot ping -h localhost' \
--health-interval=20s \
--health-timeout=3s \
--health-retries=5 \
mysql:5.6
