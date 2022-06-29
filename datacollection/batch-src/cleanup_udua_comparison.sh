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
Identifiers="Chart Cli Closure Codec Collections Compress Csv Gson JacksonCore JacksonDatabind JacksonXml Jsoup JxPath Lang Math Mockito Time"

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

blockLang="Lang;2b Lang;6b Lang;11b Lang;25b Lang;35b Lang;36b Lang;37b Lang;38b Lang;39b Lang;40b Lang;41b Lang;42b Lang;43b Lang;44b Lang;45b Lang;46b Lang;47b Lang;48b Lang;49b Lang;50b Lang;51b Lang;52b Lang;53b Lang;54b Lang;55b Lang;56; Lang;57b Lang;58b Lang;59b Lang;60b Lang;61b Lang;62b Lang;63b Lang;64b"

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
