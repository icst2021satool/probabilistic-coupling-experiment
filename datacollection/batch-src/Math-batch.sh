#!/usr/bin/env bash
set -x
DataCollectionHome=$DATACOLLECTION_HOME
cd ${DataCollectionHome}
src/faultdetect_project.sh Math 1 40 commons-math1.zip -fdp -copy -cleanup >& Math-1-40-fdp-duas.out
gzip Math-1-40-fdp-duas.out

src/faultdetect_project.sh Math 41 80 commons-math2.zip -fdp -copy -cleanup >& Math-41-80-fdp.out
gzip Math-41-80-fdp.out

src/faultdetect_project.sh Math 81 106 commons-math3.zip -fdp -copy -cleanup >& Math-81-106-fdp-duas.out
gzip Math-81-106-fdp-duas.out
