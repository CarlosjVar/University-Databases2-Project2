## Repository for course: database II
This readme helps you to perform the intended labs in classroom regarding topics such as mapreduce with hadoop, hive, spark and kafka.

### docker related  

Everytime you rerun the preexisting hadoopserver container you must run the `./start.sh` command.

Build the image, create an internal network and run the image using a local volumen
path to share files and jars from the host computer
```
docker build . -t hadoop

docker network create --driver bridge --subnet 10.0.0.0/28 littlenet

docker run -it -p 9000:9000 -p 9092:9092 -p 22:22 -v C:\Applications\GitHub\University-Databases2-Project2\mapr:/home/hadoopuser/mapr --name hadoopserver --net littlenet --ip 10.0.0.2 hadoop
```

This is an example of how to manually copy files from the host to the container 
```
docker cp maprexample.jar hadoopserver:/home/hadoopuser
docker cp datadates.csv  hadoopserver:/home/hadoopuser
```

### ssh related
The image includes a default user setup, the user "hadoopuser" must grant passwordless access by ssh, this is required for the hadoop server
This is run once per container.
```
su - hadoopuser
cd /home/hadoopuser
ssh-keygen -t rsa -P '' -f /home/hadoopuser/.ssh/id_rsa
ssh-copy-id hadoopuser@localhost
exit
```

### hadoop related
These are the commands to start/stop the hadoop single node cluster 
```
start-all.sh
stop-all.sh
```

### hive related
To setup the hive environment just run the `hive-setup.sh` script located in hadoopuser home folder
Then access the hive console with `hive`
```

```

### Kakfa related
To start the kafkta server just the script `start-kafka.sh` located in the hadoopuser home folder.

To test your Kafka environment follow the [kafka quickstart guide](https://kafka.apache.org/quickstart) 

