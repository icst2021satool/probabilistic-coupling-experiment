#!/usr/bin/env bash
set -x
DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}
src/faultdetect_project.sh Collections 25 28 commons-collections.zip -fdp -copy -cleanup >& Collections-fdp.out
gzip Collections-fdp.out

src/faultdetect_project.sh Collections 25 28 commons-collections.zip -ochiai -copy -cleanup >& Collections-ochiai.out
gzip Collections-ochiai.out
