#!/usr/bin/env bash
set -x
DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}
src/faultdetect_project.sh Cli 1 40 commons-cli.zip -fdp -copy -cleanup >& Cli-fdp.out
gzip Cli-fdp.out
