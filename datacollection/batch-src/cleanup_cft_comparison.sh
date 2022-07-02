#!/usr/bin/env bash

# Should be run from "datacollection" directory. Change to your directory "datacollection"

DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}

mkdir -p results/duas-vs-cfts

Identifiers="Chart Cli Closure Codec Collections Compress Csv Gson JacksonCore JacksonXml Jsoup JxPath Lang Math Mockito Time"

echo "Remove unreliable versions data"

blockChart="Chart-6b Chart-8b Chart-10b" # Chart-6b is added to be cleaned up because in the uncontrained duas vs. duas comparison it is cleaned up due to the fact that the fdp is 0.0 for both uncontrained duas and duas.

blockCli="Cli-6b"

blockClosure="Closure-63b Closure-93b Closure-137b Closure-143b"

blockCompress="Compress-44b"

blockCsv="Csv-15b Csv-16b"
blockCsv=""

blockGson="Gson-8b"

blockJacksonCore="JacksonCore-5b JacksonCore-19b JacksonCore-23b JacksonCore-25b"

blockJacksonDatabind="JacksonDatabind;44b JacksonDatabind;45b JacksonDatabind-95b"

blockLang="Lang-2b Lang-6b Lang-11b Lang-25b Lang-35b Lang-36b Lang-37b Lang-38b Lang-39b Lang-40b Lang-41b Lang-42b Lang-43b Lang-44b Lang-45b Lang-46b Lang-47b Lang-48b Lang-49b Lang-50b Lang-51b Lang-52b Lang-53b Lang-54b Lang-55b Lang-56b Lang-57b Lang-58b Lang-59b Lang-60b Lang-61b Lang-62b Lang-63b Lang-64b"

blockMath="Math-3b Math-55b Math-89b"

blockMockito=""

blockTime="Time-21b"

blocklist="$blockChart $blockClosure $blockCli $blockClosure $blockCompress $blockCsv $blockGson $blockJacksonCore $blockJacksonDatabind $blockLang $blockMath $blockMockito $blockTime"

cp results/duas-vs-cfts/duas-vs-cfts.csv tmp$$

for b  in $blocklist
do
        echo $b
        cat tmp$$ | grep -v deprecated | grep -v "does not exist" | grep -v $b > tmp1-$$
        mv tmp1-$$ tmp$$
done


cat tmp$$ > results/duas-vs-cfts/duas-vs-cfts-fixed.csv
rm -f tmp$$
