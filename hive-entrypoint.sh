#!/bin/bash

# Dependecy validation
while ! nc -z yarn 8088;
  do
    echo Waiting yarn...;
    sleep 1;
  done;
  echo Connected!;
  
while ! nc -z mysql 3306;
  do
    echo Waiting mysql...;
    sleep 1;
  done;
  echo Connected!;


# Setting hdfs permitions
#sed -i 's/<value>teste</<value>thrift:\/\/127.0.0.1:9083</g' /usr/local/hive/conf/hive-site.xml
schematool --verbose -initSchema -dbType mysql  > /dev/null 2>&1
/usr/local/hive/bin/hiveserver2

echo "Hive is up!"

##
## Workaround for graceful shutdown. ....ing Sqoop... ‿( ́ ̵ _-`)‿
##
 while [ '' == '' ]; do
    sleep 1    
  done
  ;;


