#!/usr/bin/env bash
set -x
DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}
src/faultdetect_project.sh Jsoup 1 93 jsoup.zip -fdp -copy -cleanup >& Jsoup-fdp.out
gzip Jsoup-fdp.out

