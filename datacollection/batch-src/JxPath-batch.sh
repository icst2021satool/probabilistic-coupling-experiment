#!/usr/bin/env bash
set -x
DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}
src/faultdetect_project.sh JxPath 1 22 commons-jxpath.zip -fdp -copy -cleanup >& JxPath-fdp.out
gzip JxPath-fdp.out
