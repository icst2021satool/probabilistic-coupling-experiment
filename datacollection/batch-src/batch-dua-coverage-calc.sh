#!/usr/bin/env bash
#set -x
DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}

echo "Chart:"
rm -f results/Chart/Chart-duacov.csv
src/coverage_csv.sh Chart

echo "Cli:"
rm -f results/Cli/Cli-duacov.csv
src/coverage_csv.sh Cli

echo "Closure:"
rm -f results/Closure/Closure-duacov.csv
src/coverage_csv.sh Closure

echo "Codec:"
rm -f results/Codec/Codec-duacov.csv
src/coverage_csv.sh Codec

echo "Collections:"
rm -f results/Collections/Collections-duacov.csv
src/coverage_csv.sh Collections

echo "Compress:"
rm -f results/Compress/Compress-duacov.csv
src/coverage_csv.sh Compress

echo "Csv:"
rm -f results/Csv/Csv-duacov.csv
src/coverage_csv.sh Csv

echo "Gson:"
rm -f results/Gson/Gson-duacov.csv
src/coverage_csv.sh Gson

echo "JacksonCore:"
rm -f results/JacksonCore/JacksonCore-duacov.csv
src/coverage_csv.sh JacksonCore

echo "JacksonDatabind:"
rm -f results/JacksonDatabind/JacksonDatabind-duacov.csv
src/coverage_csv.sh JacksonDatabind

echo "JacksonXml:"
rm -f results/JacksonXml/JacksonXml-duacov.csv
src/coverage_csv.sh JacksonXml

echo "Jsoup:"
rm -f results/Jsoup/Jsoup-duacov.csv
src/coverage_csv.sh Jsoup

echo "JxPath:"
rm -f results/JxPath/JxPath-duacov.csv
src/coverage_csv.sh JxPath

echo "Math:"
rm -f results/Math/Math-duacov.csv
src/coverage_csv.sh Math

echo "Mockito:"
rm -f results/Mockito/Mockito-duacov.csv
src/coverage_csv.sh Mockito

echo "Time:"
rm -f results/Time/Time-duacov.csv
src/coverage_csv.sh Time
