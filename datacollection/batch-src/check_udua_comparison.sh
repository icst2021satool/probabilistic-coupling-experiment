#!/usr/bin/env bash
#
# This script checks csv file with aggregated "Fault Detection Probability -- FDP".
# 
# Versions with issues were not cleaned up yet
#
# 

# Should be run from "datacollection" directory. Change to your directory "datacollection"

DataCollectionHome=/home/chaim/experimentos/probabilistic-coupling-repo/datacollection
cd ${DataCollectionHome}

Identifiers="Chart Cli Closure Codec Collections Compress Csv Gson JacksonCore JacksonDatabind JacksonXml Jsoup JxPath Math Time"
notIdentifiers="Lang Mockito Weka"

echo "==> No UncFdp, SubFdp data:"
for projectid in $Identifiers
do
	#echo "$projectid: "
	cat results/uncduas-vs-subduas/${projectid}*.csv | awk -F ";" '{if ($3 == 0.000000 && $3 == $6) print}' | sort
done
echo "==> UncFdp < SubFdp "
for projectid in $Identifiers
do
	echo "$projectid: "
	cat results/uncduas-vs-subduas/${projectid}*.csv | awk -F ";" '{if ($3 < $6) print }'
done
echo "==> notclear:"
for projectid in $Identifiers
do
	echo "$projectid: "
	cat results/uncduas-vs-subduas/${projectid}*.csv | awk -F ";" '{if ($5 == "notclear") print}'
done

echo ""
echo "Checking final csv file after cleanup: uncduas-vs-subduas-fixed.csv"
echo ""
notclear=`cat results/uncduas-vs-subduas/uncduas-vs-subduas-fixed.csv | grep notclear | awk -F ";" '{printf " results/%s/%s/fdp-%s-%s.csv ",$1,$2,$1,$2}'`

#echo $notclear
for v in $notclear
do
echo "==> $v: "
sed -n -e 2p $v
sed -n -e 3p $v
sed -n -e 4p $v
sed -n -e 5p $v
sed -n -e 6p $v
done

for v in $notclear
do
status=`sed -n -e 2p $v |awk -F ";" '{print $2,$3}'`
echo "==> $v:$status "
done


echo "==> checking number of versions"
totalversions=0

for v in $Identifiers
do
   noversions=`grep $v results/uncduas-vs-subduas/uncduas-vs-subduas-fixed.csv | wc| awk '{print $1}'`
   echo "==> $v:$noversions "
   totalversions=$((totalversions+noversions))
done
echo "==> total versions:$totalversions "
