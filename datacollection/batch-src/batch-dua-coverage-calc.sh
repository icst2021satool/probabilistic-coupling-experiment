#!/usr/bin/env bash
#set -x
DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}

#echo "Chart:"
#rm -f results/Chart/Chart-duacov.csv
#for v in {1..26}
#do
#  rm -f results/Chart/${v}b/duacoverage.txt
#  src/coverage_project.sh Chart ${v}b jfreechart.zip > results/Chart/${v}b/duacoverage.txt
#done
#src/coverage_csv.sh Chart

echo "Cli:"
rm -f results/Cli/Cli-duacov.csv
for v in {1..39}
do
  rm -f results/Cli/${v}b/duacoverage.txt
  src/coverage_project.sh Cli ${v}b commons-cli.zip > results/Cli/${v}b/duacoverage.txt
done
src/coverage_csv.sh Cli

echo "Closure:"
rm -f results/Closure/Closure-duacov.csv
for v in {1..10}
do
  rm -f results/Closure/${v}b/duacoverage.txt
  src/coverage_project.sh Closure ${v}b closure-compiler1.zip > results/Closure/${v}b/duacoverage.txt
done
for v in {11..30}
do
  rm -f results/Closure/${v}b/duacoverage.txt
  src/coverage_project.sh Closure ${v}b closure-compiler2.zip > results/Closure/${v}b/duacoverage.txt
done
for v in {31..50}
do
  rm -f results/Closure/${v}b/duacoverage.txt
  src/coverage_project.sh Closure ${v}b closure-compiler3.zip > results/Closure/${v}b/duacoverage.txt
done
for v in {51..70}
do
  rm -f results/Closure/${v}b/duacoverage.txt
  src/coverage_project.sh Closure ${v}b closure-compiler4.zip > results/Closure/${v}b/duacoverage.txt
done
for v in {71..90}
do
  rm -f results/Closure/${v}b/duacoverage.txt
  src/coverage_project.sh Closure ${v}b closure-compiler5.zip > results/Closure/${v}b/duacoverage.txt
done
for v in {91..110}
do
  rm -f results/Closure/${v}b/duacoverage.txt
  src/coverage_project.sh Closure ${v}b closure-compiler6.zip > results/Closure/${v}b/duacoverage.txt
done
for v in {111..130}
do
  rm -f results/Closure/${v}b/duacoverage.txt
  src/coverage_project.sh Closure ${v}b closure-compiler7.zip > results/Closure/${v}b/duacoverage.txt
done
for v in {131..150}
do
  rm -f results/Closure/${v}b/duacoverage.txt
  src/coverage_project.sh Closure ${v}b closure-compiler8.zip > results/Closure/${v}b/duacoverage.txt
done
for v in {151..176}
do
  rm -f results/Closure/${v}b/duacoverage.txt
  src/coverage_project.sh Closure ${v}b closure-compiler9.zip > results/Closure/${v}b/duacoverage.txt
done
src/coverage_csv.sh Closure

echo "Codec:"
rm -f results/Codec/Codec-duacov.csv
for v in {1..18}
do
  rm -f results/Codec/${v}b/duacoverage.txt
  src/coverage_project.sh Codec ${v}b commons-codec.zip > results/Codec/${v}b/duacoverage.txt
done
src/coverage_csv.sh Codec

echo "Collections:"
rm -f results/Collections/Collections-duacov.csv
for v in {25..28}
do
  rm -f results/Collections/${v}b/duacoverage.txt
  src/coverage_project.sh Collections ${v}b commons-collections.zip > results/Collections/${v}b/duacoverage.txt
done
src/coverage_csv.sh Collections

echo "Compress:"
rm -f results/Compress/Compress-duacov.csv
for v in {1..47}
do
  rm -f results/Compress/${v}b/duacoverage.txt
  src/coverage_project.sh Compress ${v}b commons-compress.zip > results/Compress/${v}b/duacoverage.txt
done
src/coverage_csv.sh Compress

echo "Csv:"
rm -f results/Csv/Csv-duacov.csv
for v in {1..16}
do
  rm -f results/Csv/${v}b/duacoverage.txt
  src/coverage_project.sh Csv ${v}b commons-csv.zip > results/Csv/${v}b/duacoverage.txt
done
src/coverage_csv.sh Csv

echo "Gson:"
rm -f results/Gson/Gson-duacov.csv
for v in {1..18}
do
  rm -f results/Gson/${v}b/duacoverage.txt
  src/coverage_project.sh Gson ${v}b gson.zip > results/Gson/${v}b/duacoverage.txt
done
src/coverage_csv.sh Gson

echo "JacksonCore:"
rm -f results/JacksonCore/JacksonCore-duacov.csv
for v in {1..26}
do
  rm -f results/JacksonCore/${v}b/duacoverage.txt
  src/coverage_project.sh JacksonCore ${v}b jackson-core.zip > results/JacksonCore/${v}b/duacoverage.txt
done
src/coverage_csv.sh JacksonCore

echo "JacksonDatabind:"
rm -f results/JacksonDatabind/JacksonDatabind-duacov.csv
for v in {1..112}
do
  rm -f results/JacksonDatabind/${v}b/duacoverage.txt
  src/coverage_project.sh JacksonDatabind ${v}b jackson-databind.zip > results/JacksonDatabind/${v}b/duacoverage.txt
done
src/coverage_csv.sh JacksonDatabind

echo "JacksonXml:"
rm -f results/JacksonXml/JacksonXml-duacov.csv
for v in {1..6}
do
  rm -f results/JacksonXml/${v}b/duacoverage.txt
  src/coverage_project.sh JacksonXml ${v}b jackson-dataformat-xml.zip > results/JacksonXml/${v}b/duacoverage.txt
done
src/coverage_csv.sh JacksonXml

echo "Jsoup:"
rm -f results/Jsoup/Jsoup-duacov.csv
for v in {1..93}
do
  rm -f results/Jsoup/${v}b/duacoverage.txt
  src/coverage_project.sh Jsoup ${v}b jsoup.zip > results/Jsoup/${v}b/duacoverage.txt
done
src/coverage_csv.sh Jsoup

echo "JxPath:"
rm -f results/JxPath/JxPath-duacov.csv
for v in {1..22}
do
  rm -f results/JxPath/${v}b/duacoverage.txt
  src/coverage_project.sh JxPath ${v}b commons-jxpath.zip > results/JxPath/${v}b/duacoverage.txt
done
src/coverage_csv.sh JxPath

echo "Lang:"
rm -f results/Lang/Lang-duacov.csv
for v in {1..34}
do
  rm -f results/Lang/${v}b/duacoverage.txt
  src/coverage_project.sh Lang ${v}b commons-lang.zip > results/Lang/${v}b/duacoverage.txt
done
src/coverage_csv.sh Lang

echo "Math:"
rm -f results/Math/Math-duacov.csv
for v in {1..40}
do
  rm -f results/Math/${v}b/duacoverage.txt
  src/coverage_project.sh Math ${v}b commons-math1.zip > results/Math/${v}b/duacoverage.txt
done
for v in {41..80}
do
  rm -f results/Math/${v}b/duacoverage.txt
  src/coverage_project.sh Math ${v}b commons-math2.zip > results/Math/${v}b/duacoverage.txt
done
for v in {81..106}
do
  rm -f results/Math/${v}b/duacoverage.txt
  src/coverage_project.sh Math ${v}b commons-math3.zip > results/Math/${v}b/duacoverage.txt
done
src/coverage_csv.sh Math

echo "Mockito:"
rm -f results/Mockito/Mockito-duacov.csv
for v in {1..38}
do
  rm -f results/Mockito/${v}b/duacoverage.txt
  src/coverage_project.sh Mockito ${v}b mockito.zip > results/Mockito/${v}b/duacoverage.txt
done
src/coverage_csv.sh Mockito

echo "Time:"
rm -f results/Time/Time-duacov.csv
for v in {1..26}
do
  rm -f results/Time/${v}b/duacoverage.txt
  src/coverage_project.sh Time ${v}b joda-time.zip > results/Time/${v}b/duacoverage.txt
done
src/coverage_csv.sh Time
