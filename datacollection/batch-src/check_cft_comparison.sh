#!/usr/bin/env bash

# Should be run from "datacollection/batch-src" directory. Change to your directory "datacollection/batch-src"

DataCollectionHome=${DATACOLLECTION_HOME}

cd ${DataCollectionHome}

#Identifiers="Chart Cli Closure Codec Collections Compress Csv Gson JacksonCore JacksonDatabind JacksonXml Jsoup JxPath Lang Math Mockito Time Weka"
Identifiers="Chart Cli Closure Codec Collections Compress Csv Gson JacksonDatabind JacksonCore JacksonXml Jsoup JxPath Math Time"

for projectid in $Identifiers
do
	echo "$projectid: False"
	cat results/duas-vs-cfts/*.txt | grep $projectid | grep -v chaim | grep False
	echo "$projectid: False;True"
	cat results/duas-vs-cfts/*.txt | grep $projectid | grep -v chaim | grep "False;True"
	echo "$projectid: False;False"
	cat results/duas-vs-cfts/*.txt | grep $projectid | grep -v chaim | grep "False;False"
	echo "$projectid: True;False"
	cat results/duas-vs-cfts/*.txt | grep $projectid | grep -v chaim | grep "True;False"
	echo "$projectid: fdp_dua < fdp_edge ||  fdp_dua < fdp_node"
	cat results/duas-vs-cfts/*.txt | grep $projectid | grep -v chaim | awk -F ";" '{if ($3 < $4|| $3 < $5) print $1,$2,$3,$4,$5,$6,$7 }'
	echo "$projectid: noclear"
	cat results/duas-vs-cfts/*.txt | grep $projectid | grep -v chaim | grep notclear
done


echo ""
echo "Checking final csv file after cleanup: no of notclears"
echo ""

#notclear=`cat results/duas-vs-cfts/duas-vs-cfts-fixed.csv | grep notclear | awk -F ";" '{printf " results/%s/%s/fdp-%s-%s.csv ",$1,$2,$1,$2}'`
cat results/duas-vs-cfts/duas-vs-cfts-fixed.csv | grep notclear | awk -F ";" '{if($6 == "notclear" || $7 == "notclear") print}'

notclears=`cat results/duas-vs-cfts/duas-vs-cfts-fixed.csv | grep notclear | awk -F ";" '{if($6 == "notclear" || $7 == "notclear") print}' | wc| awk '{print $1}'`

echo "# of notclears: $notclears"

echo ""
echo "Checking final csv file after cleanup: DUAnode sub: False; DUAedge sub: False"
echo ""

cat results/duas-vs-cfts/duas-vs-cfts-fixed.csv | grep "False;False"

falsefalses=`cat results/duas-vs-cfts/duas-vs-cfts-fixed.csv | grep "False;False" | wc | awk '{print $1}'`
echo "# of falsefalses: $falsefalses"

echo ""
echo "Checking final csv file after cleanup: DUAnode sub: True; DUAedge sub: False"
echo ""

cat results/duas-vs-cfts/duas-vs-cfts-fixed.csv | grep "True;False"

truefalses=`cat results/duas-vs-cfts/duas-vs-cfts-fixed.csv | grep "True;False" | wc | awk '{print $1}'`
echo "# of falsefalses: $truefalses"

echo ""
echo "Checking final csv file after cleanup: DUAnode sub: False; DUAedge sub: True"
echo ""

cat results/duas-vs-cfts/duas-vs-cfts-fixed.csv | grep "False;True"

falsetrues=`cat results/duas-vs-cfts/duas-vs-cfts-fixed.csv | grep "False;True" | wc | awk '{print $1}'`
echo "# of falsefalses: $falsetrues"

echo ""
echo "Checking final csv file after cleanup: DUAnode sub: True; DUAedge sub: True"
echo ""

cat results/duas-vs-cfts/duas-vs-cfts-fixed.csv | grep "True;True"

truetrues=`cat results/duas-vs-cfts/duas-vs-cfts-fixed.csv | grep "True;True" | wc | awk '{print $1}'`
echo "# of truetrues: $truetrues"

echo ""
echo "Checking final csv file after cleanup: fdp_dua < fdp_node or fdp_dua < fdp_edge"
echo ""
cat results/duas-vs-cfts/duas-vs-cfts-fixed.csv | awk -F ";" '{if ($3 < $4|| $3 < $5) print }'
lessfdps=`cat results/duas-vs-cfts/duas-vs-cfts-fixed.csv | grep -v Version | awk -F ";" '{if ($3 < $4|| $3 < $5) print}' | wc | awk '{print $1}'`

echo "# of less fdp_duas: $lessfdps"

vlessfdps=`cat  results/duas-vs-cfts/duas-vs-cfts-fixed.csv | grep -v Version | awk -F ";" '{if ($3 < $4|| $3 < $5) print}' | awk -F ";" '{ print $1 }'`

for v in $vlessfdps
do
echo ""
bugfile=`echo $v | sed -e "s/b//g"| awk -F "-" '{printf " results/%s/%sb/%s-%s.buggy.lines",$1,$2,$1,$2}'`
duafdpfile=`echo $v | awk -F "-" '{printf " results/%s/%s/fdp-%s-%s.csv ",$1,$2,$1,$2}'`
edgefdpfile=`echo $v | awk -F "-" '{printf " results/%s/%s/fdp-%s-edge-%s.csv ",$1,$2,$1,$2}'`
nodefdpfile=`echo $v | awk -F "-" '{printf " results/%s/%s/fdp-%s-node-%s.csv ",$1,$2,$1,$2}'`

echo "==>$bugfile"
cat $bugfile
echo $duafdpfile
echo "==> $duafdpfile: "
sed -n -e 2p $duafdpfile
sed -n -e 3p $duafdpfile
sed -n -e 4p $duafdpfile
sed -n -e 5p $duafdpfile
sed -n -e 6p $duafdpfile

echo $edgefdpfile
sed -n -e 2p $edgefdpfile
sed -n -e 3p $edgefdpfile
sed -n -e 4p $edgefdpfile
sed -n -e 5p $edgefdpfile
sed -n -e 6p $edgefdpfile

echo $nodefdpfile
sed -n -e 2p $nodefdpfile
sed -n -e 3p $nodefdpfile
sed -n -e 4p $nodefdpfile
sed -n -e 5p $nodefdpfile
sed -n -e 6p $nodefdpfile
done

echo "==> checking number of versions"
totalversions=0

for v in $Identifiers
do
   noversions=`grep $v results/duas-vs-cfts/duas-vs-cfts-fixed.csv | wc| awk '{print $1}'`
   echo "==> $v:$noversions "
   totalversions=$((totalversions+noversions))
done
echo "==> total versions:$totalversions"
