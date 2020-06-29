# Docker container for Superset demo with Oracle 11.2 client.

Objective
------------
The purpose of this project is to create a superset container with oracle client to allow the data analyses/visualization of data stored in an oracle database. The oracle client used is 11.2.0.4

Requirements
------------
Docker
Ports available:

Superset
```
8088
```

Usage
-----

Build container from Dockerfile using

```
sudo ./build.sh
```

or

```
docker build -t wdmsyf/superset-oracle .
```

Run container in daemon mode with

```
sudo ./run.sh
```

or

```
docker run -p 8088:8088 -name=superset -d wdmsyf/superset-oracle:<tag>
```

Open Superset in browser using the following link:
```
http://docker_host_ip:8088
# User: admin
# Password: superset_admin
用户名和密码在执行 run.sh 提示用户输入
```

```

Connect to running container with
```
docker exec -it <container_id> /bin/bash
```

Oracle数据库连接字符串：
oracle://<user>:<passwd>@<ip or hostname>:1521/orcl
