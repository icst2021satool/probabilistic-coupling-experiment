#!/usr/bin/env bash
set -x
# Add you datacollection directory path

DataCollectionHome=$DATACOLLECTION_HOME

cd ${DataCollectionHome}
src/faultdetect_project.sh Closure 1 10 closure-compiler1.zip -fdp -copy -cleanup >& Closure-1-10-fdp-duas.out
gzip Closure-1-10-fdp-duas.out

src/faultdetect_project.sh Closure 11 30 closure-compiler2.zip -fdp -copy -cleanup >& Closure-11-30-fdp-duas.out
gzip Closure-11-30-fdp-duas.out

src/faultdetect_project.sh Closure 31 50 closure-compiler3.zip -fdp -copy -cleanup >& Closure-31-50-fdp-duas.out
gzip Closure-31-50-fdp-duas.out

src/faultdetect_project.sh Closure 51 70 closure-compiler4.zip -fdp -copy -cleanup >& Closure-51-70-fdp-duas.out
gzip Closure-51-70-fdp-duas.out

src/faultdetect_project.sh Closure 71 90 closure-compiler5.zip -fdp -copy -cleanup >& Closure-71-90-fdp-duas.out
gzip Closure-71-90-fdp-duas.out

src/faultdetect_project.sh Closure 91 110 closure-compiler6.zip -fdp -copy -cleanup >& Closure-91-110-fdp-duas.out
gzip Closure-91-110-fdp-duas.out

src/faultdetect_project.sh Closure 111 130 closure-compiler7.zip -fdp -copy -cleanup >& Closure-111-130-fdp-duas.out
gzip Closure-111-130-fdp-duas.out

src/faultdetect_project.sh Closure 131 150 closure-compiler8.zip -fdp -copy -cleanup >& Closure-131-150-fdp-duas.out
gzip Closure-131-150-fdp-duas.out

src/faultdetect_project.sh Closure 151 176 closure-compiler9.zip -fdp -copy -cleanup >& Closure-151-176-fdp-duas.out
gzip Closure-151-176-fdp-duas.out
