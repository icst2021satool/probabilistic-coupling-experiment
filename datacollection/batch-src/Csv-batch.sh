#!/usr/bin/env bash
set -x
DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}
src/faultdetect_project.sh Csv 1 16 commons-csv.zip -fdp -copy -cleanup >& Csv-fdp.out
gzip Csv-fdp.out

src/faultdetect_project.sh Csv 1 16 commons-csv.zip -ochiai -copy -cleanup >& Csv-ochiai.out
gzip Csv-ochiai.out
