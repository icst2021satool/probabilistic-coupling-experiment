#!/usr/bin/env bash
set -x
DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}
src/faultdetect_project.sh JacksonCore 1 26 jackson-core.zip -fdp -copy -cleanup >& JacksonCore-fdp.out
gzip JacksonCore-fdp.out

