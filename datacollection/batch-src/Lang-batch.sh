#!/usr/bin/env bash
set -x
DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}
src/faultdetect_project.sh Lang 1 64 commons-lang.zip -fdp -copy -cleanup >& Lang-fdp.out
gzip Lang-fdp.out
mkdir -p output
mv Lang-fdp.out.gz output
