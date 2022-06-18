#!/usr/bin/env bash
set -x
DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}
src/faultdetect_project.sh Mockito 1 38 mockito.zip -fdp -copy -cleanup >& Mockito-fdp.out
gzip Mockito-fdp.out

