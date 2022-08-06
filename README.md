# Probabilistic coupling experiment

## Data generation
This repository contains the *probabilistic coupling* [1] (referred to here as *fault detection probability* -- FDP)  data for a subset of defects4j (d4j) projects as well the scripts to calculate them. We use data flow coverage collected with a modified version of Jaguar [2] to calculate FDP. 

It includes:
1. a link to Jaguar's raw data needed to calculated FDP;
2. the scripts to generate FDP for each faulty version;
3. the FDP for each version of d4j's projects;
4. cvs files aggregating the highest FDP for every faulty version. 

In what follows, we describe the structure of directories of the repository and the data they contain.


### datacollection

[``datacollection``](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection) is the *root*  directory. It has the following sub-directories: ``src, batch-src, results, coverage, subsumption-files``, ``scripts`` and ``satool``.

There are two auxiliary files in this directory: 
1. [projects.d4j](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/projects.d4j): lists the d4j's identifiers and project names and 
2. [versions.d4j](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/versions.d4j): lists   identifiers,  project names, and  active versions of the d4j repository.  
which are used by the scripts to generate FDP data.

In what follows, we describe **datacollection**'s directories.

### datacollection/src:

This directory contains the shell scripts and Python programs to generate the FDP for each faulty version of each project. We list below the Python programs and  the shell scripts of ```datacollection/src```.

* [init.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/init.sh)  
* [comparisonv2.py](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/comparisonv2.py)   
* [datafilegen.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/datafilegen.sh)  
* [faultdetect_project.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/faultdetect_project.sh) 
* [faultdetectv3.py](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/faultdetectv3.py) 
* [get_buggy_lines.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/get_buggy_lines.sh)  
* [coverage_project.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/coverage_project.sh) 
* [coverage_jaguar.py](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/coverage_jaguar.py)  
* [coverage_csv.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/coverage_csv.sh) 
* [duacftcomparison.py](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/duacftcomparison.py) 
* [duacftcomparison_batch.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/duacftcomparison_batch.sh) 
* [duafdpaggregation.py](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/duafdpaggregation.py)

The main files are the shell scripts **datafilegen.sh**, **faultdetect_project.sh**, **duacftcomparison_batch.sh**, **duacftcomparison.py**, and **duafdpaggregation.py**. They are detailed below.

#### datafilegen.sh
[datafilegen.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/datafilegen.sh) generates several data related to the calculation of the fault detection probability (FDP) or ochiai association metric.  This script supposes it is run at **datacolletion** directory using ```src/datafilegen.sh```. The parameters are as follows:
* arg[1] Name of the project (e.g., Chart, Math)
* arg[2] Version (e.g., 2b)
* arg[3] Zip file with jaguar DUA coverage data for the d4j project under analysis. This zip file includes data flow coverage for all faulty versions of a d4j project. See **datacollection/coverage** section for the description and location of zip files.
* arg[4] Data file to be generated (e.g., -fdp, -ochiai)
* arg[5] -copy: Copy faulty classes
* arg[6] -cleanup: clean up the static and dynamic data (e.g., json, matrix, spectra files) used to generate FDP data file

arg[3] options:
1. -fdp --  generate fault detection probability (FDP) for a particular faulty version
2. -ochiai -- ochiai fault localization association metric for a particular faulty version
3. datafilegen.sh has other options beyond -fdp  and -ochiai that are not relevant for fault detection probability (FDP) or fault localization.

<!--

4. -edgematrix -- edge coverage data from data flow jaguar coverage
5. -nodematrix -- node coverage data from data flow jaguar coverage
6. -cftmatrix -- edge and node coverage data from data flow jaguar coverage
7. -fdpnode -- fault detection probability for edge coverage from jaguar coverage
8. -fdpedge -- fault detection probability for node coverage from jaguar coverage
9. -fdpcft -- fault detection probability for node and edge coverage from jaguar coverage
10. -ochiai -- ochai fault detection association metric.
11. -edgematrix -- edge coverage data from data flow jaguar coverage
12. -nodematrix -- node coverage data from data flow jaguar coverage
13. -cftmatrix -- edge and node coverage data from data flow jaguar coverage
-->

**datafilegen.sh** calls [coverage_project.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/coverage_project.sh), [get_buggy_lines.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/get_buggy_lines.sh), [faultdetectv3.py](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/faultdetectv3.py), and [comparisonv2.py](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/comparisonv2.py) to generate the csv/json files. **comparisonv2.py** checks whether the DUA sets generated by SATool and Jaguar are the same; **faultdetectv3.py** calculates the FDP. Csv and json files are created with the FDP data for a particular d4j project and version;  they contain the same information. The names of the csv and json files are fixed: `fdp-PROJECTID-VERSION.json`, `fdp-PROJECTID-VERSION.csv`, `ochiai-PROJECTID-VERSION.json`, and `ochiai-PROJECTID-VERSION.csv`. **datafilegen.sh** also copies the buggy classes; that is, the classes where the bug is located and, additionally, generates a file listing the buggy lines of the buggy classes. It utilizes the [get_buggy_lines.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/get_buggy_lines.sh) shell script (developed by d4j team) to located the buggy lines. Additionally, **datafilegen.sh** calls [coverage_project.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/coverage_project.sh) which invokes [coverage_jaguar.py](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/coverage_jaguar.py) to determine the DUA coverage for a particular faulty version of a d4j's project.

**datafilegen.sh** saves the FDP csv and json files  on ```results/PROJECTID/VERSION``` directory, being ```PROJECTID``` the project identifier (e.g., Chart) and ```VERSION``` the version identifier (e.g., 11b). This very same directory will receive java files of ```VERSION```'s faulty classes, json files with subsumption data for these faulty classes, and file ```duacoverage.txt``` which contains the DUA coverage for ```VERSION```.

For example, by running the command below:
*  ```src/datafilegen.sh Chart 2b jfreechart.zip -fdp -copy -cleanup```  

**datafilegen.sh** saves csv and json files containing FDP (or ochiai) data on ```results/Chart/2b``` directory. The descriptions of these files are presented at [results directory](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/README.md#datacollectionresults)

<!--
edgematrix/nodematrix/cftmatrix: edge and node matrix files are saved on the  *subsumption-files/PROJECT_NAME/reduce/VERSION* directory. To keep the matrix files one should not use the -cleanup option; otherwise,  they are gzipped in a single file and moved to **subsumption-files/reduce** folder. **datafilegen.sh** calls  **createcftmatrix.py** to generate the matrix files. To generate fdp and ochiai rankings from the gzip file, it has to be converted to a zip file and moved to the **coverage/PROJECTID** folder. For fdp and ochiai ranking calculation is supposed that a zip file with the matrix data is located at **coverage/PROJECTID** folder.
-->

#### faultdetect_project.sh

[faultdetect_project.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/faultdetect_project.sh) runs **datafilegen.sh** on several faulty versions.

Example: ```src/faultdetect_project.sh Compress 1 47 commons-compress-exception.zip -fdp -copy -cleanup```

In the example, **faultdetect_project.sh** calls **datafilegen.sh** for each of 47 active versions of project Compress.


#### duacftcomparison_batch.sh

[duacftcomparison_batch.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/duacftcomparison_batch.sh) firstly generates the subsumption files and then calls the python program [src/duacftcomparison.py](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/duacftcomparison.py) for  all faulty versions of a d4j project. 

Example: ```src/duacftcomparison_batch.sh Chart 1 26 >& results/duas-vs-cfts/Chart-dua-cft-comparison.txt```

In this example, **duacftcomparison_batch.sh** generates the subsumption files and calls **duacftcomparison.py** for all Chart's faults. The output of its execution is saved on ``results/duas-vs-cfts/Chart-dua-cft-comparison.txt`` which will be used to aggregate  fault detection ability of DUA versus DUA-node and DUA-edge subsmption on cvs files (see discussion on **batch-src/batch-duacft-comparison.sh**). 

[batch-duacft-comparison.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/batch-duacft-comparison.sh) invokes **duacftcomparison_batch.sh** for all d4j's projects. (See descripton below)

#### duacftcomparison.py

[duacftcomparison.py](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/duacftcomparison.py) identifies the top fault revealing DUAs for a particular faulty version and checks whether they are subsumed by nodes and edge coverage. It generates a file with this information called ``fdp-dua-cft-comparison-VERSION.json`` and saves it on the ```datacollection/results/PROJECTID/VERSION```directory.


#### duafdpaggregation.py

This python program aggregates data for all faulty versions of a particular d4j project. It is called by 
[gen_csv_udua_dua_comparison.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/gen_csv_udua_dua_comparison.sh) to generate cvs files that aggregate maximum FDP for all d4j projects.  (See description below) 

Example: ``src/duafdpaggregation.py Chart 1 26 ./results results/uncduas-vs-subduas/Chart1-26.csv``

The result of its execution  for Chart is saved on ``results/uncduas-vs-subduas/Chart1-26.csv``

#### get_buggy_lines.sh,comparisonv2.py, and faultdetectv3.py

These are scripts or python programs called by **datafilegen.sh**. See details of them in the description of **datafilegen.sh**.

#### init.sh,  coverage_project.sh, coverage_jaguar.py, and coverage_csv.sh

* [init.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/init.sh) sets up environment variables to run scripts. 
* [coverage_project.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/coverage_project.sh) generates  DUA coverage using the matrix files generated by jaguar for all faulty versions.
* [coverage_jaguar.py](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/coverage_jaguar.py) generates  DUA coverage using the matrix files generated by jaguar for a particular faulty version.
* [coverage_csv.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/coverage_csv.sh) generates csv files with DUA coverage using the matrix files generated by jaguar.


### datacollection/batch-src:

This directory contains scripts whose purpose is to run scripts contained in the directory ``datacollection/src`` for several d4j's projects at once (e.g., in batch mode) or to generate, clean up, and check the aggregate FDP data. There are four types of scrips:

1. Scripts to collect FDP data in batch mode. These scripts basically run the script **src/faultdetect_project.sh** for all faulty versions of the d4j projects.

* [Chart-batch.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/Chart-batch.sh)
* [Cli-batch.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/Cli-batch.sh)	      
* [Closure-batch-fdp.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/Compress-batch.sh)  
* [Codec-batch.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/Codec-batch.sh)	    
* [Collections-batch.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/Collections-batch.sh)  
* [Compress-batch.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/Closure-batch.sh)     
* [Csv-batch.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/Csv-batch.sh)	  
* [Gson-batch.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/Gson-batch.sh)	  
* [JacksonCore-batch.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/JacksonCore-batch.sh)  
* [JacksonDatabind-batch.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/JacksonDatabind-batch.sh)  
* [JacksonXml-batch.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/JacksonXml-batch.sh)	    
* [Jsoup-batch.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/Jsoup-batch.sh)	    
* [JxPath-batch.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/JxPath-batch.sh)  
* [Lang-batch.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/Lang-batch.sh)    
* [Math-batch.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/Math-batch.sh)
* [Mockito-batch.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/Mockito-batch.sh)
* [Time-batch.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/Time-batch.sh)

2. Scripts to generate csv file for analysis.
* [batch-duacft-comparison.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/batch-duacft-comparison.sh). This script runs script **src/duacftcomparison_batch.sh** for all d4j's projects. [duacftcomparison_batch.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/duacftcomparison_batch.sh), in itself, is a batch script since it calls **src/duacftcomparison.py** for every faulty version of a particular d4j project. Script [duacftcomparison.py](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/duacftcomparison.py) determine whether control flow criteria (edge and node coverage) subsumes those DUAs with the highest FDP value.

3.  Scripts to generate subsumption-files for a d4j project.

* [batch-subsumption-files.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/batch-src/batch-subsumption-files.sh). This script invokes **src/faultdetect_project.sh** (and implicitly **src/datafilegen.sh**) to generate the subsumption files for all fault versions of the d4j's projects. Additionally, a tar.gz file is created with all subsumption files for all versions compressed. The targ.gz files are saved on ```subsumption-files/PROJECTID```.

4. Scripts to cleanup data from unreliable versions.

5. Scripts to check the results.

#### Scripts to collect data in batch mode

### datacollection/coverage:

**coverage** has a sub-directory for each of d4j's projects. In each of these sub-directories there should be one or more zip files containing the data flow coverage collected with Jaguar. Because the zip files occupy too much space, we make them availabe at [here](https://drive.google.com/drive/folders/1Yv_nWJrwMO1twRaqXZ3e34JWFLArYjeN?usp=sharing). 

To run the scripts to generate the FDP data for each version, one should place the project's zip file containing its data flow coverage on the project's folder. 

The table below maps each project identifier to its zip file contained [here](https://drive.google.com/drive/folders/1Yv_nWJrwMO1twRaqXZ3e34JWFLArYjeN?usp=sharing). **Math** and **Closure** required to divide their coverage data into several files, each one containg a subset of the faulty versions' coverage. 

  Identifier     |      Project zip file | Versions
------------------| ----------------------|--------- 
Chart            | jfreechart.zip  | all d4j versions
Cli              | commons-cli.zip | all d4j versions 
Closure          | closure-compiler1.zip | 1-10|
Closure          | closure-compiler2.zip | 11-30|
Closure          | closure-compiler3.zip | 31-50|
Closure          | closure-compiler4.zip | 51-70|
Closure          | closure-compiler5.zip | 71-90|
Closure          | closure-compiler6.zip | 91-110|
Closure          | closure-compiler7.zip | 111-130|
Closure          | closure-compiler8.zip | 131-150|
Closure          | closure-compiler9.zip | 151-176|
Codec            | commons-codec.zip | all d4j versions
Collections      | commons-collections.zip | all d4j versions
Compress         | commons-compress.zip | all d4j versions
Csv              | commons-csv.zip | all d4j versions
Gson             | gson.zip | all d4j versions
JacksonCore      | jackson-core.zip | all d4j versions
JacksonDatabind  | JacksonDatabind.zip | all d4j versions
JacksonXml       | jackson-dataformat-xml | all d4j versions
Jsoup            | jsoup.zip | all d4j versions
JxPath           | commons-jxpath.zip | all d4j versions
Lang             | commons-lang.zip | 1-34
Math             | commons-math1.zip | 1-40
Math             | commons-math2.zip | 41-80
Math             | commons-math3.zip | 81-106
Mockito          | mockito.zip | all d4j versions
Time             | joda-time.zip | all  d4j versions

This repository has already the `datacollection/coverage/PROJECTID` directories, but it does not contain the coverage zip files due to space restrictions. 

For example, let us say one wants to generate data for project **Chart**, the zip file **jfreechart.zip** should be placed at ```datacolection/coverage/Chart```. **datafilegen.sh** will look for the zip file at ```datacollection/coverage/Chart/jfreechart.zip``` when the command below is issued:
*  ```src/datafilegen.sh Chart 2b jfreechart.zip -fdp -copy -cleanup``` 

The data from **Chart 2b** is expanded using ```datacollection/coverage/Chart/jfreechart.zip``` when **datafilegen.sh** generates FDP data. 

### datacollection/results
The ``datacollection/results`` contains a sub-directory for each of the d4j's projects and also two sub-directories that aggregate the FDP data for comparing  DUAs versus unconstrained DUAs and the comparison between DUA coverage and edge and node coverage with respect to their fault detection ability.

#### results/uncduas-vs-subduas

This [results/uncduas-vs-subduas](https://github.com/icst2021satool/probabilistic-coupling-experiment/tree/master/datacollection/results/uncduas-vs-subduas) directory has csv files that aggregate the FDP data for d4j's projects and also all projects. 
The cvs files for d4j's projects are  not cleaned up for unreliable versions (see Table III in the STVR paper) and are used to generated [uncduas-vs-subduas-fixed.csv](https://github.com/icst2021satool/probabilistic-coupling-experiment/tree/master/datacollection/results/uncduas-vs-subduas/uncduas-vs-subduas-fixed.csv) in which these data were removed. The [uncduas-vs-subduas-plot.csv](https://github.com/icst2021satool/probabilistic-coupling-experiment/tree/master/datacollection/results/uncduas-vs-subduas/uncduas-vs-subduas-plot.csv) file was used to generate the violin plots (Figures 11 and 12). We show an excerpt of this file below.


```
Program;Version;UncFdpMax;NoUncFdpMax;Status;SubFdpMax;NoSubFdpMax;LessFdpUnc;MoreFdpUnc;FdpMaxDF
Chart;11b;0.062500;5;clear;0.062500;20;False;False;0.062500
Chart;12b;0.250000;4;clear;0.000000;0;False;True;0.250000
Chart;13b;1.000000;130;clear;1.000000;26;False;False;1.000000
Chart;14b;0.133333;4;clear;0.000000;0;False;True;0.133333
Chart;15b;1.000000;5;clear;0.000000;0;False;True;1.000000
```

The columns ``Program``, ``Version``, ``UncFdpMax``, ``NoUncFdpMax``, ``Status``, ``SubFdpMax``, ``NoSubFdpMax``, ``LessFdpUnc``, ``MoreFdpUnc``, and
``FdpMaxDF`` refer to the following information:
1. **Program**: d4j project,
2. **Version**: fault,
3. **UncFdpMax**:  maximum FDP for unconstrained DUAs,
4. **NoUncFdpMax**: number of unconstrained DUAs with maximum FDP,
5. **Status**: whether the method of the maximum FDP DUAs was cleared for subsumption calculation; that is, SAtool was able to find the subsumption relationship for the method,
6. **SubFdpMax**:  maximum FDP for subsumed DUAs,
7. **NoSubFdpMax**: number of subsumed DUAs with maximum FDP,
8. **LessFdpUnc**:  boolean value informing if UncFdpMax < SubFdpMax,
9. **MoreFdpUnc**: boolean value informing if UncFdpMax > SubFdpMax,
10. **FdpMaxDF**: maximum between UncFdpMax and SubFdpMax -- Max(UncFdpMax,SubFdpMax).


#### results/duas-vs-cfts

This repository contains data regarding the yield of data flow testing. It contains cvs files showing whether the top fault revealing DUAs are subsumed by edges and nodes. It contains txt files that are the output of the execution of duacftcomparison_batch.sh for each d4j's projects. The relevant file is 
[duas-vs-cfts-fixed.csv](https://github.com/icst2021satool/probabilistic-coupling-experiment/tree/master/datacollection/results/duas-vs-cfts/duas-vs-cfts-fixed.csv); it contains the data cleared of unreliable versions (STVR's paper Table III). Below we show an excerpt of this file.

```
Version;TopDUAsStatus;DUAMaxFdp;NodeMaxFdp;EdgeMaxFdp;topDUANodeSubsumption;topDUAEdgeSubsumption;
Chart-1b;clear;1.0;0.0;0.0;True;True;
Chart-2b;clear;1.0;0.0;0.0;True;True;
Chart-3b;clear;0.3333;0.0;0.0;True;True;
Chart-4b;clear;1.0;0.0;0.0;True;True;
Chart-5b;clear;0.5;0.0;0.0;True;True;
```

The columns ``Version``, ``TopDUAsStatus``, ``DUAMaxFdp``, ``NodeMaxFdp``, ``EdgeMaxFdp``, ``topDUANodeSubsumption``, and ``topDUAEdgeSubsumption`` refer to the following information:
1. **Version**: d4j project and fault,
3. **TopDUAsStatus**:  status o top fault revealing DUAs; that is, whether SAtool was able to find the DUA-edge and DUA-node subsumptions relationshiop for all top DUAs,
4. **DUAMaxFdp**: maximum FDP for unconstrained DUAs,,
5. **NodeMaxFdp**: unavailable information (always zero),
6. **EdgeMaxFdp**: unavailable information (always zero),
7. **topDUANodeSubsumption**: boolean value indicating whether node coverage subsumes at least one top fault revealing DUA,
8. **topDUAEdgeSubsumption**: boolean value indicating whether edge coverage subsumes at least one top fault revealing DUA.
 
#### results/PROJECTID

**results** has a sub-directory for each of the d4j's projects. And for each project, there is a sub-directory for every faulty version. These latter directories contain the FDP  or ochiai data generated. We discuss the contents of the main files below.

Csv and json files are saved on ```results/PROJECTID/VERSION``` directory after the execution of **datafilegen.sh**; they contain the DUAs sorted by the FDP or ochiai ranking.  The following files are generated at  [datacollection/results/Chart/2b](https://github.com/icst2021satool/probabilistic-coupling-experiment/tree/master/datacollection/results/Chart/2b):

* [fdp-Chart-2b.csv](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/results/Chart/2b/fdp-Chart-2b.csv) (contains Chart 2b DUAs ranked by FDP)
* [fdp-Chart-2b.json](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/results/Chart/2b/fdp-Chart-2b.json) (it has the same information contained in the csv file)
* [DatasetUtilities.java](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/results/Chart/2b/DatasetUtilities.java)  (buggy class of Chart 2b)
* [Chart-2.buggy.lines](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/results/Chart/2b/Chart-2.buggy.lines) (contains the buggy lines of Chart 2b)
* [duacoverage.txt](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/results/Chart/2b/duacoverage.txt) (DUA coverage for the faulty version collect using Jaguar and BA-DUA)
* [fdp-dua-cft-comparison-2b.json](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/results/Chart/2b/fdp-dua-cft-comparison-2b.json) (it indicates whether the top DUAs are subsumed or not by node and edge coverage)
* [org.jfree.data.general.DatasetUtilities.duas.json](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/results/Chart/2b/org.jfree.data.general.DatasetUtilities.duas.json) (it contains the DUAs of the fault revealing class in json format)
* [jaguar.out](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/results/Chart/2b/jaguar.out) (output from Jaguar)
* [tests.out](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/results/Chart/2b/tests.out) (output from Junit execution; not present in all versions)

Below we present the top line of the file `results/Chart/2b/fdp-Chart-2b.csv`, the main result file:

```
FAULT DETECTION ;Uncon;Status;DUAs; Version;2b
1.000000;True;clear;org.jfree.data.xy.XYIntervalSeriesCollection%getSeries#1@7$(
113,116, series)
```
#### Contents of cvs files
The cvs files contain the following columns:

1. **FAULT DETECTION**: a *real value f* (O < f <= 1.0) informing the probabilistic coupling (or fault detection probability -- FDP) calculated using all tests belonging to the test suite created by the project's developers. We refer the reader to [Chen et al. 2020 ASE paper](https://doi.org/10.1145/3324884.3416667) for the definition of probablistic coupling.
2. **Uncon**: **true** means the DUA (definition use association) is unconstrained and **false** subsumed; we refer the reader to the paper for the definition of unconstrained and subsumed DUAs. 
3. **Status**: **clear** means that the Subsumption Algorithm (SA) could calculate the subsumption relationship for the method's DUAs; **notclear** means SA could not find the subsumption relationship. 
4. **DUAs**: the description of the DUA; we refer the reader to the paper for the definition of definition use associations (DUAs).

For the excerpt of `results/Chart/2b/fdp-Chart-2b.csv`:
* FAULT DETECTION: 1.0;
* Uncon: clear;
* DUA:`org.jfree.data.xy.XYIntervalSeriesCollection%getSeries#1@7$(
113,116, series)`

Regarding the DUA description:
* `org.jfree.data.xy.XYIntervalSeriesCollection` is the class name;
* `%` is a delimiter
* `getSeries` is the method's name
* `#` is a delimiter
* 1 is the method's identifier;
* `@` is a delimiter
* 7 is the DUA's identifier;
* `$` is a  delimiter
* `(113,116, series)` is the DUA description where 113 is the line where the definition occurs, 116 is the line where the use occurs, and `series` is the name of the variable object of the data flow.


### datacollection/subsumption-files

**subsumption-files** contains a sub-directory for each of the d4j's projects.
They contain subsumption  information (DUA-DUA subsumption, DUA-edge subsumption and DUA-node subsumption), coverage requirements (DUAs, nodes, edges required), and mapping information (DUA to nodes and DUA  to edges) for every method of every class of a faulty version in analysis. 
The contents of these files are used to compare the fault dectation ability of unconstrained and subsumed DUAs and to assess the yield of data flow coverage vis-a-vis control flow coverage.
The subsumption data are generated in the form of json files. We describe below the contents of each of the json files used in the STVR paper.  

1. `<Class name>`.**nodes.json**. Lists the nodes (**node id**) of every method and associates them to the lines of program. Below we lists Chart 1b `org.jfree.data.xy.YWithXInterval.nodes.json`.
```
{
"Class" : "org.jfree.data.xy.YWithXInterval", 
"Methods" : [{ "Name" : "equals" ,
"Nodes" : 12,
"0" : [ 114 ],
"1" : [ 117 ],
"2" : [ 120,121 ],
"3" : [ 124 ],
"4" : [ 127 ],
"5" : [ 130 ],
"6" : [ 128 ],
"7" : [ 125 ],
"8" : [ 122 ],
"9" : [ 118 ],
"10" : [ 115 ],
"11" : [  ]
}]
}
```
2. `<Class name>`.**edges.json**. Lists the **edges ids**   and associates them to the edges of program. Below we lists Chart 1b `org.jfree.data.xy.YWithXInterval.edges.json`.
```
{
"Class" : "org.jfree.data.xy.YWithXInterval", 
"Methods" : [{ "Name" : "equals" ,
"Edges" : 16,
"0" : [ 7,11 ],
"1" : [ 2,8 ],
"2" : [ 2,3 ],
"3" : [ 9,11 ],
"4" : [ 6,11 ],
"5" : [ 10,11 ],
"6" : [ 5,11 ],
"7" : [ 1,9 ],
"8" : [ 1,2 ],
"9" : [ 4,6 ],
"10" : [ 4,5 ],
"11" : [ 0,10 ],
"12" : [ 0,1 ],
"13" : [ 3,7 ],
"14" : [ 3,4 ],
"15" : [ 8,11 ]
}]
}
```
4. `<Class name>`.**duas.json**. Contains the description of the DUAs belonging to each method of the class. Each DUA of a method has an identifier number (**id number**) which are used in the matrix coverage file (created by Jaguar) to refer to the covered DUAs. Below we show excerpts of Chart 1b `org.jfree.data.xy.YWithXInterval.duas.json`.
```
{
"Class" : "org.jfree.data.xy.YWithXInterval", 
"Methods" : [{ "Name" : "equals" ,
"Duas" : 31,
"0" :  "(114,(114,115), this)",
"1" :  "(114,(114,117), this)",

...
"28" :  "(120,(124,127), that.xLow)",
"29" :  "(120,(127,128), that.xHigh)",
"30" :  "(120,(127,130), that.xHigh)"}]
}
```
3. `<Class name>`.**sub.json**. This file describes the leaves of the *reduced subsumption graph* (RSG) for each method of a particular class (in our example, Chart 1b `org.jfree.data.xy.YWithXInterval.duas.json`), the unconstrained DUAs in the leaves, and also the DUAs subsumed by the unconstrained DUAs. 
We refer the reader to the STVR paper for the description of the reduced subsumption graph.
 This file lists, for each leaf of the  method's RSG
(refered to as ``"<number>"``),  a list of *id numbers* of unconstrained DUAs.  The DUAs subsumed by leave ``"<number>"``'s unconstrained DUAs is referred to as ``"S<number>"`` and its associated list of subsumed DUAs. Below we show the contents of Chart 1b `org.jfree.data.xy.YWithXInterval.sub.json`.
In the example file, label ``Subsumers`` informs the number of leaves; leave ``5`` has a single unconstrained DUA whose identifer is ``10`` which, in turn, subsumes DUAs ``1, 9, and 10`` as indicated in the label ``S5``.
```
{
"Class" : "org.jfree.data.xy.YWithXInterval", 
"Methods" : [{ "Name" : "equals" ,
"Duas" : "31" ,
"Subsumers" : 6,
"0" : [ 8, 0], "S0" : [0, 8 ],
"1" : [ 25, 19, 13, 2], "S1" : [1, 2, 9, 11, 12, 13, 19, 25 ],
"2" : [ 27, 21, 15, 4], "S2" : [1, 3, 4, 9, 11, 12, 14, 15, 20, 21, 26, 27 ],
"3" : [ 29, 23, 17, 6], "S3" : [1, 3, 5, 6, 9, 11, 12, 14, 16, 17, 20, 22, 23, 26, 28, 29 ],
"4" : [ 30, 24, 18, 7], "S4" : [1, 3, 5, 7, 9, 11, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30 ],
"5" : [ 10], "S5" : [1, 9, 10 ]
}]
}
```
4. `<Class name>`.**edgesub.json**. This file describes the DUAs subsumed whenever a method's edge is covered. Every identifier of an edge is associated with a list of the subsumed DUAs. Below we show the contents of Chart 1b `org.jfree.data.xy.YWithXInterval.edgesub.json`.

```
{
"Class" : "org.jfree.data.xy.YWithXInterval", 
"Methods" : [{ "Name" : "equals" ,
"Edges" : 16,
"11" : [ 0, 8],
"12" : [ 1, 9],
"7" : [ 1, 9, 10],
"8" : [ 1, 9, 11, 12],
"1" : [ 1, 2, 19, 9, 25, 11, 12, 13],
"2" : [ 1, 3, 20, 9, 26, 11, 12, 14],
"13" : [ 1, 3, 4, 20, 21, 9, 26, 11, 27, 12, 14, 15],
"14" : [ 16, 1, 3, 20, 5, 22, 9, 26, 11, 12, 28, 14],
"9" : [ 1, 3, 5, 6, 9, 11, 12, 14, 16, 17, 20, 22, 23, 26, 28, 29],
"10" : [ 1, 3, 5, 7, 9, 11, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30],
"6" : [ 1, 3, 5, 7, 9, 11, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30],
"4" : [ 1, 3, 5, 6, 9, 11, 12, 14, 16, 17, 20, 22, 23, 26, 28, 29],
"0" : [ 1, 3, 4, 9, 11, 12, 14, 15, 20, 21, 26, 27],
"15" : [ 1, 2, 9, 11, 12, 13, 19, 25],
"3" : [ 1, 9, 10],
"5" : [ 0, 8],
"CoveredDUAsByEdges" : 31,
"Duas" : 31
}]
}
```

5. `<Class name>`.**nodesub.json**. This file describes the DUAs subsumed whenever a method's node is covered. Every identifier of a node is associated with a list of the subsumed DUAs. Below we show the contents of Chart 1b `org.jfree.data.xy.YWithXInterval.nodesub.json`.
```
{
"Class" : "org.jfree.data.xy.YWithXInterval", 
"Methods" : [{ "Name" : "equals" ,
"Nodes" : 12,
"0" : [ ],
"1" : [ 1, 9],
"2" : [ 1, 9, 11, 12],
"3" : [ 1, 3, 20, 9, 26, 11, 12, 14],
"4" : [ 16, 1, 3, 20, 5, 22, 9, 26, 11, 12, 28, 14],
"5" : [ 1, 3, 5, 7, 9, 11, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30],
"6" : [ 1, 3, 5, 6, 9, 11, 12, 14, 16, 17, 20, 22, 23, 26, 28, 29],
"7" : [ 1, 3, 4, 9, 11, 12, 14, 15, 20, 21, 26, 27],
"8" : [ 1, 2, 9, 11, 12, 13, 19, 25],
"9" : [ 1, 9, 10],
"10" : [ 0, 8],
"11" : [ ],
"CoveredDUAsByNodes" : 31,
"Duas" : 31
}]
}
```
Whenever one runs **datafilegen.sh** for a particular d4j's project ``PROJECTID`` and version ``VERSION``, the subsumption files are generated and saved on
folder ``datacollection/subsumption-files/PROJECTID/reduce/VERSION``.
These files can optionally be removed after the execution of the scripts 
to generate FDP data.
In order to save space, **subsumption files** are available compressed [here](https://drive.google.com/drive/folders/1r9YyHduev5Ig1RG7I-ENkjcqND2ker0M?usp=sharing)
for the d4j's projects, excepting Lang and Mockito.

### datacollection/satool

This directory contains the **satool** jar file and the libraries it uses. **satool** generates the json files of the **subsumption-files** directory.

# References

[1] Yiqun T. Chen, Rahul Gopinath, Anita Tadakamalla, Michael D. Ernst, Reid Holmes, Gordon Fraser, Paul Ammann, and René Just. 2020. Revisiting the relationship between fault detection, test adequacy criteria, and test set size. In <i>Proceedings of the 35th IEEE/ACM International Conference on Automated Software Engineering</i> (<i>ASE '20</i>). Association for Computing Machinery, New York, NY, USA, 237–249. [DOI](https://doi.org/10.1145/3324884.3416667)

[2] H. Ribeiro, R. de Araujo, M. Chaim, H. de Souza and F. Kon,  "Jaguar: A Spectrum-Based Fault Localization Tool for Real-World Software," in 2018 IEEE 11th International Conference on Software Testing, Verification and Validation (ICST), Vasteras, Sweden, 2018 pp. 404-409.
[DOI](https://doi.org/10.1109/ICST.2018.00048)

