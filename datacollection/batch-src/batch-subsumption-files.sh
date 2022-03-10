#!/usr/bin/env bash
set -x
DataCollectionHome=/home/chaim/experimentos/probabilistic-coupling-repo/datacollection
cd ${DataCollectionHome}

#
# This script invokes faultdetect_project.sh (and implicitly datafilegen.sh) to 
# generate the subsumption files for all fault versions of the d4j's projects. 
# Additionally, a tar.gz file is created with all subsumption files for all versions 
# compressed.

# Zip files are useless. They're kept only to avoid an error for lack of parameters
#

echo "Chart:"
src/faultdetect_project.sh Chart 1 26 jfreechart.zip -subsumption -ncopy -cleanup  

echo "Cli:"
src/faultdetect_project.sh Cli 1 40 commons-cli.zip -subsumption -ncopy -cleanup

echo "Closure:"
src/faultdetect_project.sh Closure 1 176 closure-compiler1.zip -subsumption -ncopy -cleanup 

echo "Codec:"
src/faultdetect_project.sh Codec 1 18 commons-codec.zip -subsumption -ncopy -cleanup

echo "Collections:"
src/faultdetect_project.sh Collections 25 28 commons-collections.zip -subsumption -ncopy -cleanup 

echo "Compress:"
src/faultdetect_project.sh Compress 1 47 commons-compress.zip -subsumption -ncopy -cleanup 

echo "Csv:"
src/faultdetect_project.sh Csv 1 16 commons-csv.zip -subsumption -ncopy -cleanup 

echo "Gson:"
src/faultdetect_project.sh Gson 1 18 gson.zip -subsumption -ncopy -cleanup 

echo "JacksonCore:"
src/faultdetect_project.sh JacksonCore 1 26 jackson-core.zip -subsumption -ncopy -cleanup 

echo "JacksonDatabind:"
src/faultdetect_project.sh JacksonDatabind 1 112 jackson-databind.zip -subsumption -ncopy -cleanup 

echo "JacksonXml:"
src/faultdetect_project.sh JacksonXml 1 6 jackson-dataformat-xml.zip -subsumption -ncopy -cleanup 

echo "Jsoup:"
src/faultdetect_project.sh Jsoup 1 93 Jsoup.zip -subsumption -ncopy -cleanup 

echo "JxPath:"
src/faultdetect_project.sh JxPath 1 22 commons-jxpath.zip -subsumption -ncopy -cleanup 
echo "Math:"
src/faultdetect_project.sh Math 1 106 commons-math1.zip -subsumption -ncopy -cleanup 

echo "Time:"
src/faultdetect_project.sh Time 1 27 joda-time.zip -subsumption -ncopy -cleanup 
