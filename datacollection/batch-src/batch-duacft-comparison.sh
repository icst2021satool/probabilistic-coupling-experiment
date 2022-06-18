#!/usr/bin/env bash
#set -x
DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}
mkdir -p results/duas-vs-cfts

echo "Chart:"
rm -f results/duas-vs-cfts/Chart-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Chart 1 26 >& results/duas-vs-cfts/Chart-dua-cft-comparison.txt

echo "Cli:"
rm -f results/duas-vs-cfts/Cli-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Cli 1 40 >& results/duas-vs-cfts/Cli-dua-cft-comparison.txt

echo "Closure:"
rm -f results/duas-vs-cfts/Closure1-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Closure 1 10 >& results/duas-vs-cfts/Closure1-dua-cft-comparison.txt

rm -f results/duas-vs-cfts/Closure2-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Closure 11 30 >& results/duas-vs-cfts/Closure2-dua-cft-comparison.txt

rm -f results/duas-vs-cfts/Closure3-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Closure 31 50 >& results/duas-vs-cfts/Closure3-dua-cft-comparison.txt

rm -f results/duas-vs-cfts/Closure4-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Closure 51 70 >& results/duas-vs-cfts/Closure4-dua-cft-comparison.txt

rm -f results/duas-vs-cfts/Closure5-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Closure 71 90 >& results/duas-vs-cfts/Closure5-dua-cft-comparison.txt

rm -f results/duas-vs-cfts/Closure6-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Closure 91 110 >& results/duas-vs-cfts/Closure6-dua-cft-comparison.txt

rm -f results/duas-vs-cfts/Closure7-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Closure 111 130 >& results/duas-vs-cfts/Closure7-dua-cft-comparison.txt

rm -f results/duas-vs-cfts/Closure8-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Closure 131 150 >& results/duas-vs-cfts/Closure8-dua-cft-comparison.txt

rm -f results/duas-vs-cfts/Closure9-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Closure 151 176 >& results/duas-vs-cfts/Closure9-dua-cft-comparison.txt

echo "Codec:"
rm -f results/duas-vs-cfts/Codec-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Codec 1 18 >& results/duas-vs-cfts/Codec-dua-cft-comparison.txt

echo "Collections:"
rm -f results/duas-vs-cfts/Collections-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Collections 25 28 >& results/duas-vs-cfts/Collections-dua-cft-comparison.txt

echo "Compress:"
rm -f results/duas-vs-cfts/Compress-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Compress 1 47 >& results/duas-vs-cfts/Compress-dua-cft-comparison.txt

echo "Csv:"
rm -f results/duas-vs-cfts/Csv-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Csv 1 16 >& results/duas-vs-cfts/Csv-dua-cft-comparison.txt

echo "Gson:"
rm -f results/duas-vs-cfts/Gson-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Gson 1 18 >& results/duas-vs-cfts/Gson-dua-cft-comparison.txt

echo "JacksonCore:"
rm -f results/duas-vs-cfts/JacksonCore-dua-cft-comparison.txt
src/duacftcomparison_batch.sh JacksonCore 1 26 >& results/duas-vs-cfts/JacksonCore-dua-cft-comparison.txt

echo "JacksonDatabind:"
rm -f results/duas-vs-cfts/JacksonDatabind-dua-cft-comparison.txt
src/duacftcomparison_batch.sh JacksonDatabind 1 112 >& results/duas-vs-cfts/JacksonDatabind-dua-cft-comparison.txt

echo "JacksonXml:"
rm -f results/duas-vs-cfts/JacksonXml-dua-cft-comparison.txt
src/duacftcomparison_batch.sh JacksonXml 1 6 >& results/duas-vs-cfts/JacksonXml-dua-cft-comparison.txt

echo "Jsoup:"
rm -f results/duas-vs-cfts/Jsoup-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Jsoup 1 93 >& results/duas-vs-cfts/Jsoup-dua-cft-comparison.txt

echo "JxPath:"
rm -f results/duas-vs-cfts/JxPath-dua-cft-comparison.txt
src/duacftcomparison_batch.sh JxPath 1 22 >& results/duas-vs-cfts/JxPath-dua-cft-comparison.txt

echo "Math:"
rm -f results/duas-vs-cfts/Math1-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Math 1 40 >& results/duas-vs-cfts/Math1-dua-cft-comparison.txt

rm -f results/duas-vs-cfts/Math2-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Math 41 80 >& results/duas-vs-cfts/Math2-dua-cft-comparison.txt

rm -f results/duas-vs-cfts/Math3-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Math 81 106 >& results/duas-vs-cfts/Math3-dua-cft-comparison.txt

echo "Mockito:"
rm -f results/duas-vs-cfts/Mockito-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Mockito 1 38 >& results/duas-vs-cfts/Mockito-dua-cft-comparison.txt

echo "Time:"
rm -f results/duas-vs-cfts/Time-dua-cft-comparison.txt
src/duacftcomparison_batch.sh Time 1 27 >& results/duas-vs-cfts/Time-dua-cft-comparison.txt
