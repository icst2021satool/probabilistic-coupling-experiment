#
# This script generates csv file with aggregated "Fault Detection Probability -- FDP".
# 
# Versions with issues were not cleaned up yet
#
# 

# Should be run from "datacollection" directory. Change to your directory "datacollection"

DataCollectionHome=${DATACOLLECTION_HOME}
cd ${DataCollectionHome}
 
Identifiers="Chart Cli Closure Codec Collections Compress Csv Gson JacksonCore JacksonDatabind JacksonXml Jsoup JxPath Lang Math Mockito Time"

if [ -d "results/uncduas-vs-subduas" ]
then
    rm -rf results/uncduas-vs-subduas/*.csv
else
    mkdir results/uncduas-vs-subduas
fi

# Collect the data
src/duafdpaggregation.py Chart 1 26 ./results results/uncduas-vs-subduas/Chart1-26.csv
src/duafdpaggregation.py Cli 1 40 ./results results/uncduas-vs-subduas/Cli1-40.csv
src/duafdpaggregation.py Closure 1 176 ./results results/uncduas-vs-subduas/Closure1-176.csv
src/duafdpaggregation.py Codec 1 18 ./results results/uncduas-vs-subduas/Codec1-18.csv
src/duafdpaggregation.py Collections 25 28 ./results results/uncduas-vs-subduas/Collections25-28.csv
src/duafdpaggregation.py Compress 1 47 ./results results/uncduas-vs-subduas/Compress1-47.csv
src/duafdpaggregation.py Csv 1 16 ./results results/uncduas-vs-subduas/Csv1-16.csv
src/duafdpaggregation.py Gson 1 18 ./results results/uncduas-vs-subduas/Gson1-18.csv
src/duafdpaggregation.py JacksonCore 1 26 ./results results/uncduas-vs-subduas/JacksonCore1-26.csv
src/duafdpaggregation.py JacksonDatabind 1 112 ./results results/uncduas-vs-subduas/JacksonDatabind1-112.csv
src/duafdpaggregation.py JacksonXml 1 6 ./results results/uncduas-vs-subduas/JacksonXml1-6.csv
src/duafdpaggregation.py Jsoup 1 93 ./results results/uncduas-vs-subduas/Jsoup1-93.csv
src/duafdpaggregation.py JxPath 1 22 ./results results/uncduas-vs-subduas/JxPath1-22.csv
src/duafdpaggregation.py Lang 1 64 ./results results/uncduas-vs-subduas/Lang1-64.csv
src/duafdpaggregation.py Math 1 106 ./results results/uncduas-vs-subduas/Math1-106.csv
src/duafdpaggregation.py Mockito 1 38 ./results results/uncduas-vs-subduas/Mockito1-38.csv
src/duafdpaggregation.py Time 1 27 ./results results/uncduas-vs-subduas/Time1-27.csv

echo "Program;Version;UncFdpMax;NoUncFdpMax;Status;SubFdpMax;NoSubFdpMax;LessFdpUnc;MoreFdpUnc;" > results/uncduas-vs-subduas/uncduas-vs-subduas.csv

for projectid in $Identifiers
do
	txtfiles=$(ls results/uncduas-vs-subduas/${projectid}*.csv)
	echo "$projectid: $txtfiles "
	cat results/uncduas-vs-subduas/${projectid}*.csv | grep -v Version | sort >> results/uncduas-vs-subduas/uncduas-vs-subduas.csv
done
