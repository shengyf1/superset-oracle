#!/bin/bash
docker run -p 8888:8088 --name=superset --restart=always -d wdmsyf/superset-oracle
