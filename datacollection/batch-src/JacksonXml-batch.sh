#!/usr/bin/env bash
set -x
DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}
src/faultdetect_project.sh JacksonXml 1 6 jackson-dataformat-xml.zip -fdp -copy -cleanup >& JacksonXml-fdp.out
gzip JacksonXml-fdp.out

