#!/usr/bin/env bash
set -x
DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}
src/faultdetect_project.sh Compress 1 47 commons-compress.zip -fdp -copy -cleanup >& Compress-fdp.out
gzip Compress-fdp.out

src/faultdetect_project.sh Compress 1 47 commons-compress.zip -ochiai -copy -cleanup >& Compress-ochiai.out
gzip Compress-ochiai.out
