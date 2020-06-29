#!/bin/bash
#docker run -p 8888:8088 --name=superset --restart=always -d wdmsyf/superset-oracle


docker run -p 8888:8088 --name=superset --restart=always -d wdmsyf/superset-oracle:20200629

#初始化数据库(基于官方版本镜像需要执行)
docker exec -it superset superset-init

