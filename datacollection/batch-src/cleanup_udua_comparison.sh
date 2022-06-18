#!/usr/bin/env bash
#
# This script generates csv file with aggregated "Fault Detection Probability -- FDP".
# 
# Versions with issues were not cleaned up yet
#
# 

# Should be run from "datacollection/batch-src" directory. Change to your directory "datacollection/batch-src"

DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}

AllIdentifiers="Chart Cli Closure Codec Collections Compress Csv Gson JacksonCore JacksonDatabind JacksonXml Jsoup JxPath Lang Math Mockito Time Weka"
Identifiers="Chart Cli Closure Codec Collections Compress Csv Gson JacksonCore JacksonDatabind JacksonXml Jsoup JxPath Math Mockito Time"

echo "==>Cleaning up \"No UncFdp, SubFdp data\":"
touch tmp$$
for projectid in $Identifiers
do
	#echo "$projectid: "
	#cat results/uncduas-vs-subduas/${projectid}*.csv | gawk -F ";" '{if ($3 != 0.000000 || $6 != 0.000000) print}' | grep -v Version |  sort
	cat results/uncduas-vs-subduas/${projectid}*.csv | awk -F ";" '{if ($3 != 0.000000 || $6 != 0.000000) print}' | grep -v Version |  sort >> tmp$$
	cat results/uncduas-vs-subduas/${projectid}*.csv | awk -F ";" '{if ($3 == 0.000000 && $6 == 0.000000) print}' | grep -v Version
done


echo "Remove unreliable versions data"

blockChart="Chart;8b Chart;10b"

blockCli="Cli;6b"

blockClosure="Closure;63b Closure;93b Closure;137b Closure;143b"

blockCompress="Compress;44b"

blockCsv="Csv;15b Csv;16b"
blockCsv=""

blockGson="Gson;8b"

blockJacksonCore="JacksonCore;5b JacksonCore;19b JacksonCore;23b JacksonCore;25b"

blockJacksonDatabind="JacksonDatabind;44b JacksonDatabind;45b JacksonDatabind;95b"

blockLang="Lang;"

blockMath="Math;3b Math;55b Math;89b"

blockMockito=""

blockTime="Time;21b"

blocklist="$blockChart $blockClosure $blockCli $blockClosure $blockCompress $blockCsv $blockGson $blockJacksonDatabind $blockJacksonCore $blockLang $blockMath $blockMockito $blockTime"

echo $blocklist

for b  in $blocklist
do
	echo $b
	cat tmp$$ | grep -v $b > tmp1-$$
	mv tmp1-$$ tmp$$
done


echo "Program;Version;UncFdpMax;NoUncFdpMax;Status;SubFdpMax;NoSubFdpMax;LessFdpUnc;MoreFdpUnc;" > results/uncduas-vs-subduas/uncduas-vs-subduas-fixed.csv
cat tmp$$ >> results/uncduas-vs-subduas/uncduas-vs-subduas-fixed.csv

echo "Program;Version;UncFdpMax;NoUncFdpMax;Status;SubFdpMax;NoSubFdpMax;LessFdpUnc;MoreFdpUnc;FdpMaxDF" > results/uncduas-vs-subduas/uncduas-vs-subduas-plot.csv

cat tmp$$ | awk -F";" '{printf ("%s;%s;%f;%d;%s;%f;%d;%s;%s;", $1,$2,$3,$4,$5,$6,$7,$8,$9); \
if($3 < $6) {printf ("%f\n",$6);} else {printf ("%f\n",$3)} }' >> results/uncduas-vs-subduas/uncduas-vs-subduas-plot.csv

rm -f tmp$$
