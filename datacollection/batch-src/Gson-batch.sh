#!/usr/bin/env bash
set -x
DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}
src/faultdetect_project.sh Gson 1 18 gson.zip -fdp -copy -cleanup >& Gson-fdp.out
gzip Gson-fdp.out

