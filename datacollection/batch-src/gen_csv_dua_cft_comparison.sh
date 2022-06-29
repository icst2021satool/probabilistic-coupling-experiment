#!/usr/bin/env bash
# Should be run from "datacollection/batch-src" directory. Change to your directory "datacollection/batch-src"

DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}

AllIdentifiers="Chart Cli Closure Codec Collections Compress Csv Gson JacksonCore JacksonDatabind JacksonXml Jsoup JxPath Lang Math Mockito Time Weka"
Identifiers="Chart Cli Closure Codec Collections Compress Csv Gson JacksonCore JacksonDatabind JacksonXml Jsoup JxPath Lang Math Mockito Time"

echo "Version;TopDUAsStatus;DUAMaxFdp;NodeMaxFdp;EdgeMaxFdp;topDUANodeSubsumption;topDUAEdgeSubsumption;" > results/duas-vs-cfts/duas-vs-cfts.csv
for projectid in $Identifiers
do
	txtfiles=$(ls results/duas-vs-cfts/${projectid}*.txt)
	echo "$projectid: $txtfiles "
	cat results/duas-vs-cfts/${projectid}*.txt| grep "${projectid}-" | grep -v chaim | grep -v nodes | grep -v OK| grep -v "cp\:" | grep -v "Error\:" | grep -v "grep\:" | grep -v "Cannot open" | grep -v "Cloning into" | grep -v "Checking out" >> results/duas-vs-cfts/duas-vs-cfts.csv
done
