#!/usr/bin/env bash
set -x
DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}
src/faultdetect_project.sh JacksonDatabind 1 112 jackson-databind.zip -fdp -copy -cleanup >& JacksonDatabind-fdp.out
gzip JacksonDatabind-fdp.out

