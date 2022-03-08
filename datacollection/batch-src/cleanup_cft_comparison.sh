#!/usr/bin/env bash

# Should be run from "datacollection" directory. Change to your directory "datacollection"

DataCollectionHome=/home/chaim/experimentos/probabilistic-coupling-repo/datacollection
cd ${DataCollectionHome}

Identifiers="Chart Cli Closure Codec Collections Compress Csv Gson JacksonCore JacksonXml Jsoup JxPath Math Time"

echo "Remove unreliable versions data"

blockChart="Chart-8b Chart-10b"

blockCli="Cli-6b"

blockClosure="Closure-63b Closure-93b Closure-137b Closure-143b"

blockCompress="Compress-44b"

blockCsv="Csv-15b Csv-16b"

blockGson="Gson-8b"

blockJacksonCore="JacksonCore-5b JacksonCore-19b JacksonCore-23b JacksonCore-25b"

blockJacksonDatabind="JacksonDatabind-95b"

blockMath="Math-3b Math-55b Math-89b"

blockMockito="Mockito-"

blockTime="Time-21b"

blocklist="$blockChart $blockClosure $blockCli $blockClosure $blockCompress $blockCsv $blockGson $blockJacksonCore  $blockJacksonDatabind $blockMath $blockMockito $blockTime"

cp results/duas-vs-cfts/duas-vs-cfts.csv tmp$$

for b  in $blocklist
do
        echo $b
        cat tmp$$ | grep -v deprecated | grep -v $b > tmp1-$$
        mv tmp1-$$ tmp$$
done


cat tmp$$ > results/duas-vs-cfts/duas-vs-cfts-fixed.csv
rm -f tmp$$
