#!/usr/bin/env bash
set -x
DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}
src/faultdetect_project.sh Chart 1 26  jfreechart.zip -fdp -copy -cleanup >& Chart-fdp.out
gzip Chart-fdp.out
