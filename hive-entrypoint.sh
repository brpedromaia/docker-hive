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

touch /etc/sudoers
chmod 555 /etc/sudoers

# Creating user hive
USERNAME="hive"
PASSWORD="hive"
USERID=1001
GROUPID=1020
USERDIR=/home/$USERNAME
SUDOER=nopasswd

echo "Creating user $USERNAME group $USERNAME"
useradd $USERNAME
groupmod -g "$GROUPID" "$USERNAME"

echo "Checking data directory $USERDIR"
[ ! -e "$USERDIR" ] && mkdir -p "$USERDIR" && chown "$USERID":"$GROUPID" "$USERDIR"

echo "Configuring user $USERNAME (uid=$USERID,gid=$GROUPID,dir=$USERDIR)"
usermod -u $USERID -o -g $GROUPID -d $USERDIR $USERNAME

# Password
echo "Setting $USERNAME password"
usermod -p $(openssl passwd "$PASSWORD") "$USERNAME"
sed -i 's/PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Sudo
sed -i '/'"$USERNAME"' ALL=.*/d' /etc/sudoers
case "$SUDOER" in
  yes)
    echo "$USERNAME ALL=(ALL) ALL" >> /etc/sudoers
    ;;
  nopasswd)
    echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers 
    ;;
  *)
    echo "No sudo power allowed"
esac

#creating .bashrc root
echo 'export HADOOP_HOME=/usr/local/hadoop'>>/root/.bashrc
echo 'export HADOOP_PREFIX=/usr/local/hadoop'>>/root/.bashrc
echo 'export HADOOP_COMMON_HOME=/usr/local/hadoop'>>/root/.bashrc
echo 'export HADOOP_HDFS_HOME=/usr/local/hadoop'>>/root/.bashrc
echo 'export HADOOP_MAPRED_HOME=/usr/local/hadoop'>>/root/.bashrc
echo 'export HADOOP_YARN_HOME=/usr/local/hadoop'>>/root/.bashrc
echo 'export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop'>>/root/.bashrc
echo 'export YARN_CONF_DIR=$HADOOP_PREFIX/etc/hadoop'>>/root/.bashrc
echo 'export PATH=$PATH:/usr/local/hadoop/bin'>>/root/.bashrc
echo 'export CLASSPATH=$CLASSPATH:/usr/local/hadoop/lib/*:/usr/local/hive/lib/*:.'>>/root/.bashrc
echo 'export PATH=$PATH:/usr/local/hive/bin'>>/root/.bashrc
echo 'export LANG=en_US.UTF-8'>>/root/.bashrc
echo 'export LC_ALL=en_US.UTF-8'>>/root/.bashrc
echo 'export JAVA_HOME=/usr/java/default'>>/root/.bashrc
echo 'export PATH=$PATH:$JAVA_HOME/bin'>>/root/.bashrc
chmod 755 /root/.bashrc

#creating .bashrc user
echo 'export HADOOP_HOME=/usr/local/hadoop'>>$USERDIR/.bashrc
echo 'export HADOOP_PREFIX=/usr/local/hadoop'>>$USERDIR/.bashrc
echo 'export HADOOP_COMMON_HOME=/usr/local/hadoop'>>$USERDIR/.bashrc
echo 'export HADOOP_HDFS_HOME=/usr/local/hadoop'>>$USERDIR/.bashrc
echo 'export HADOOP_MAPRED_HOME=/usr/local/hadoop'>>$USERDIR/.bashrc
echo 'export HADOOP_YARN_HOME=/usr/local/hadoop'>>$USERDIR/.bashrc
echo 'export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop'>>$USERDIR/.bashrc
echo 'export YARN_CONF_DIR=$HADOOP_PREFIX/etc/hadoop'>>$USERDIR/.bashrc
echo 'export PATH=$PATH:/usr/local/hadoop/bin'>>$USERDIR/.bashrc
echo 'export CLASSPATH=$CLASSPATH:/usr/local/hadoop/lib/*:/usr/local/hive/lib/*:.'>>$USERDIR/.bashrc
echo 'export PATH=$PATH:/usr/local/hive/bin'>>$USERDIR/.bashrc
echo 'export LANG=en_US.UTF-8'>>$USERDIR/.bashrc
echo 'export LC_ALL=en_US.UTF-8'>>$USERDIR/.bashrc
echo 'export JAVA_HOME=/usr/java/default'>>$USERDIR/.bashrc
echo 'export PATH=$PATH:$JAVA_HOME/bin'>>$USERDIR/.bashrc
chmod 755 $USERDIR/.bashrc
chown $USERNAME:$GROUPID $USERDIR/.bashrc

/usr/bin/ssh-keygen -A
/usr/sbin/sshd -D&

# Setting hdfs permitions

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


