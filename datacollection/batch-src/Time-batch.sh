#!/usr/bin/env bash
set -x
DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}
src/faultdetect_project.sh Time 1 27 joda-time.zip -fdp -copy -cleanup >& Time-fdp.out
gzip Time-fdp.out

src/faultdetect_project.sh Time 1 27 joda-time.zip -ochiai -copy -cleanup >& Time-ochiai.out
gzip Time-ochiai.out
