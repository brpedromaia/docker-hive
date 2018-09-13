## Apache Hadoop 2.7.7 Docker images
**[See all here](https://hub.docker.com/r/brpedromaia/hadoop/)**
# Hive Server 2 docker image

***Note: This docker image requires *docker network running* and the following containers running: ***
    01. Namenode
    02. Yarn
    03. Datanode
    04. Mysql


# Build the image

If you'd like to try directly from the Dockerfile you can build the image as:

```
docker build  -t brpedromaia/hadoop-hive:latest hive/ 
```
# Pull the image

The image is also released as an official Docker image from Docker's automated build repository - you can always pull or refer the image when launching containers.

```
docker pull brpedromaia/hadoop-hive
```


# Start a container

***In order to use the Docker image you have just build or pulled use:***

```
docker run -itd --net=dockerlan --hostname=hive --name=hive brpedromaia/hadoop-hive
```

***To enter in container***

```
docker exect -it hadoop-hive bash
```

**Make sure that SELinux is disabled on the host. If you are using boot2docker you don't need to do anything.**

```
docker run -it --net=dockerlan --hostname=hive --name=hive brpedromaia/hadoop-hive -bash
```

**You would like to have a tunnel port exposed to localhost.**

```
docker run -it --net=dockerlan --hostname=hive -p 10000:10000 -p 10002:10002 --name=hive brpedromaia/hadoop-hive
```

# Testing

You can run one of the stock examples:

```
hive -e "SHOW DATABASES;"
```

# Client config 
```
hostname: localhost
port: 10000
username: hive
password: hive
database: default
```

# Automate everything

To automate everything add code in hive-entrypoint.sh 