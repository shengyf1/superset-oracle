# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
FROM amancevice/superset:latest
MAINTAINER CFSoft Studio <wdmsyf@yahoo.com>

USER root


# Oracle instantclient
ADD oracle/instantclient-basic-linux.x64-11.2.0.4.0.zip /tmp/instantclient-basic-linux.x64-11.2.0.4.0.zip
ADD oracle/instantclient-sdk-linux.x64-11.2.0.4.0.zip /tmp/instantclient-sdk-linux.x64-11.2.0.4.0.zip
ADD oracle/instantclient-sqlplus-linux.x64-11.2.0.4.0.zip /tmp/instantclient-sqlplus-linux.x64-11.2.0.4.0.zip
add requirements-db.txt /tmp/requirements-db.txt


RUN set -x \
    && sed -i s@/deb.debian.org/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
#    && sed -i s@/deb\ http://security.debian.org/@/#deb\ http://security.debian.org/@g /etc/apt/sources.list \
    && cat /etc/apt/sources.list \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
#    && apt-get update -y \
    && apt-get update -o Acquire::CompressionTypes::Order::=gz \
    && apt-get install -y unzip \
    && apt-get install libaio-dev libsasl2-dev libldap2-dev -y \
    && echo "Unzip oracle client..." \
    && unzip /tmp/instantclient-basic-linux.x64-11.2.0.4.0.zip -d /usr/local/ \
    && unzip /tmp/instantclient-sdk-linux.x64-11.2.0.4.0.zip -d /usr/local/ \
    && unzip /tmp/instantclient-sqlplus-linux.x64-11.2.0.4.0.zip -d /usr/local/ \
    && ln -s /usr/local/instantclient_11_2 /usr/local/instantclient \
    && ln -s /usr/local/instantclient/libclntsh.so.11.1 /usr/local/instantclient/libclntsh.so \
    && ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus \
    && rm /tmp/instantclient*.zip \
    && apt-get remove unzip -y \
    && apt-get clean && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*


ENV TERM=vt100
ENV ORACLE_HOME="/usr/local/instantclient"
ENV LD_LIBRARY_PATH="/usr/local/instantclient"
RUN export PATH=$PATH:/usr/local/instantclient/bin

RUN echo '/usr/local/instantclient/' | tee -a /etc/ld.so.conf.d/oracle_instant_client.conf && ldconfig

ENV NLS_LANG='SIMPLIFIED CHINESE_CHINA.UTF8'

## Install superset
#RUN set -x \
#    && pip install -i http://pypi.douban.com/simple --trusted-host pypi.douban.com -r /tmp/requirements-db.txt \
#    && pip install -i http://pypi.douban.com/simple --trusted-host pypi.douban.com apache-superset

## copy admin password details to /superset for fabmanager
#RUN mkdir /superset
#COPY admin.config /superset/

## Create an admin user
#RUN /usr/local/bin/flask fab create-admin --app superset < /superset/admin.config

## Initialize the database
#RUN superset db upgrade

## Create default roles and permissions
#RUN superset init

## Load some data to play with
#RUN superset load_examples
 
#HEALTHCHECK CMD ["curl", "-f", "http://localhost:8088/health"]

## Start the development web server
#CMD superset runserver -d

USER superset


