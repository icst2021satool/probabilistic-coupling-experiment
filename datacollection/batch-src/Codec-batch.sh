#!/usr/bin/env bash
set -x
DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}
src/faultdetect_project.sh Codec 1 18 commons-codec.zip -fdp -copy -cleanup >& Codec-fdp.out
gzip Codec-fdp.out

