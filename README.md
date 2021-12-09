# Probabilistic coupling experiment

## Data generation
This repository contains scripts to generate and the *probabilistic coupling* [1] (referred here as *fault detection probability* -- FDP)  data for a subset of defects4j (d4j) projects using data flow coverage collected with a modified version of Jaguar [2]. It includes:
1. a link to Jaguar's raw data needed to calculated FDP;
2. the scripts to generate FDP for each faulty version;
3. the FDP for each version of d4j's projects; and
4. spreadsheets aggregating the highest FDP for every faulty version.


[1] Yiqun T. Chen, Rahul Gopinath, Anita Tadakamalla, Michael D. Ernst, Reid Holmes, Gordon Fraser, Paul Ammann, and René Just. 2020. Revisiting the relationship between fault detection, test adequacy criteria, and test set size. In <i>Proceedings of the 35th IEEE/ACM International Conference on Automated Software Engineering</i> (<i>ASE '20</i>). Association for Computing Machinery, New York, NY, USA, 237–249. [DOI](https://doi.org/10.1145/3324884.3416667)

[2] H. Ribeiro, R. de Araujo, M. Chaim, H. de Souza and F. Kon,  "Jaguar: A Spectrum-Based Fault Localization Tool for Real-World Software," in 2018 IEEE 11th International Conference on Software Testing, Verification and Validation (ICST), VÃ¤sterÃ¥s, Sweden, 2018 pp. 404-409.
[DOI](https://doi.org/10.1109/ICST.2018.00048)

In what follows, we describe the structure of directories of the repository.


### datacollection

```datacollection```is the *root*  directory. It has the following sub-directories: ```src, batch-src, results, coverage, subsumption-files```, and ```satool```.

There are two auxiliary files in this directory: 
1. [projects.d4j](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/projects.d4j): lists the  identifiers and the project names and 
2. [versions.d4j](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/versions.d4j): lists the  identifiers, the project names, and the active versions.  
which are used by the scripts to generate FDP data.

In what follows, we describe **datacollection**'s directories.

### datacollection/src:

This directory contains the shell scripts and Python programs to generate the FDP for each faulty version of each project. We list below the Python programs and  the shell scripts of ```datacollection/src```.

* [comparisonv2.py](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/comparisonv2.py)
* [datafilegen.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/datafilegen.sh)
* [faultdetect_project.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/faultdetect_project.sh)
* [faultdetectv3.py](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/faultdetectv3.py)
* [get_buggy_lines.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/get_buggy_lines.sh)

The main files are the shell scripts **datafilegen.sh** and **faultdetect_project.sh**.

#### datafilegen.sh
[datafilegen.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/datafilegen.sh) generates several data related to the calculation of the fault detection probability (FDP) or ochiai association metric.  This script supposes it is run at **datacolletion** directory using ```src/datafilegen.sh```. The parameters are as follows:
* arg[1] Name of the project (e.g., Chart, Math)
* arg[2] Version (e.g., 2b)
* arg[3] Zip file with jaguar DUA data (data flow coverage for all faulty versions of a d4j project)
* arg[4] Data file to be generated (e.g., -fdp, -ochiai)
* arg[5] -copy: Copy faulty classes
* arg[6] -cleanup: clean up the static and dynamic data (e.g., json, matrix, spectra files) used to generate FDP data file

arg[3] options:
1. -fdp --  generate fault detection probability (FDP) for a particular faulty version
2. -ochiai -- ochai fault detection association metric for a particular faulty version
3. datafilegen.sh has other options beyond -fdp (e.g., -occhiai) that are not relevant for fault detection probability (FDP)

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

**datafilegen.sh** calls  [faultdetectv3.py](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/faultdetectv3.py) and [comparisonv2.py](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/comparisonv2.py) to generate the csv/json files. Csv and json file have the same information. The names of the csv and json files are fixed: `fdp-PROJECTID-VERSION.json`, `fdp-PROJECTID-VERSION.csv`, `ochiai-PROJECTID-VERSION.json`, and `ochiai-PROJECTID-VERSION.csv`. 

**datafilegen.sh** also copies the buggy classes; that is, the classes where the bug is located and, additionally, generates a file listing the buggy lines of the buggy classes. It utilizes the [get_buggy_lines.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/get_buggy_lines.sh) shell script (developed by d4j team) to located the buggy lines. 

**datafilegen.sh** saves the csv and json files  saved on ```results/PROJECTID/VERSION``` directory, being ```PROJECTID``` the project identifier and ```VERSION``` the version identifier (e.g., 11b). 

For example, by running the command below:
*  ```src/datafilegen.sh Chart 2b jfreechart.zip -fdp -copy -cleanup```  

**datafilegen.sh** saves csv and json files containing FDP (or occhiai) data on ```results/Chart/2b``` directory. The descriptions of these files are presented at [results directory](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/README.md#datacollectionresults)

<!--
edgematrix/nodematrix/cftmatrix: edge and node matrix files are saved on the  *subsumption-files/PROJECT_NAME/reduce/VERSION* directory. To keep the matrix files one should not use the -cleanup option; otherwise,  they are gzipped in a single file and moved to **subsumption-files/reduce** folder. **datafilegen.sh** calls  **createcftmatrix.py** to generate the matrix files. To generate fdp and ochiai rankings from the gzip file, it has to be converted to a zip file and moved to the **coverage/PROJECTID** folder. For fdp and ochiai ranking calculation is supposed that a zip file with the matrix data is located at **coverage/PROJECTID** folder.
-->

#### faultdetect_project.sh

[faultdetect_project.sh](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/src/faultdetect_project.sh) runs **datafilegen.sh** on several faulty versions.

Example: ```src/faultdetect_project.sh Compress 1 47 commons-compress-exception.zip -fdp -copy -cleanup```

In the example, **faultdetect_project.sh** calls **datafilegen.sh** for each of 47 active versions of project Compress.


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
Lang             | **not available** | **none**
Math             | commons-math1.zip | 1-40
Math             | commons-math2.zip | 41-80
Math             | commons-math3.zip | 81-106
Mockito          | **not available** | **none**
Time             | joda-time.zip | all  d4j versions

This repository has already the `datacollection/coverage/PROJECTID` directories, but it does not contains the coverage zip files due to space restrictions. 

For example, let us say one wants to generate data for project **Chart**, the zip file **jfreechart.zip** should be placed at ```datacolection/coverage/Chart```. **datafilegen.sh** will look for the zip file at ```datacollection/coverage/Chart/jfreechart.zip``` when the command below is issued:
*  ```src/datafilegen.sh Chart 2b jfreechart.zip -fdp -copy -cleanup``` 

The data from **Chart 2b** is expanded using ```datacollection/coverage/Chart/jfreechart.zip``` when **datafilegen.sh** generates FDP data. 

### datacollection/results
**results** has a sub-directory for each of the d4j's projects. And for each project, there is a sub-directory for every faulty version. These latter directories contains the FDP  or ochhiai data generated.

Csv and json files are saved on ```results/PROJECTID/VERSION``` directory after the execution of **datafilegen.sh**; they contain the DUAs sorted by the FDP or occhai ranking.  The following files are generated at  [datacollection/results/Chart/2b](https://github.com/marcoschaim/probabilistic-coupling/tree/master/datacollection/results/Chart/2b):

* [fdp-Chart-2b.csv](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/results/Chart/2b/fdp-Chart-2b.csv) (contains Chart 2b DUAs ranked by FDP)
* fdp-Chart-2b.json (ignored in the repository because it has the same information contained in the csv file)
* ochiai-Chart-2b.csv (ignored in the repository because occhai data is not explored in the  paper)
* ochiai-Chart-2b.json (ignored in the repository because occhai data is not explored in the  paper)
* [DatasetUtilities.java](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/results/Chart/2b/DatasetUtilities.java)  (buggy class of Chart 2b)
* [Chart-2.buggy.lines](https://github.com/icst2021satool/probabilistic-coupling-experiment/blob/master/datacollection/results/Chart/2b/Chart-2.buggy.lines) (contains the buggy lines of Chart 2b)

#### Contents of cvs files
The cvs files contains the following columns:

1. **FAULT DETECTION**: a *real value f* (O < f <= 1.0) informing the probabilistic coupling (or fault detection probability -- FDP) calculated using all tests belonging to the test suite created by the project's developers. We refer the reader to [Chen et al. 2020 ASE paper](https://doi.org/10.1145/3324884.3416667) for the definition of probablistic coupling.
2. **Uncon**: *true* means the DUA (definition use association) is unconstrained and **false** subsumed; we refer the reader to the paper for the definition of unconstrained and subsumed DUAs. 
3. **Status**: *clear* means that the Subsumption Algorithm (SA) could calculate the subsumption relationship for the method's DUAs; *notclear* means SA could not find the subsumption relationship. 
4. **DUAs**: the description of the DUA; we refer the reader to the paper for the definition of definition use associations (DUAs).

Below we present the top line of the file `results/Closure/138b/fdp-Closure-138.csv`:

```
FAULT DETECTION ;Uncon;Status;DUAs; Version;138b
1.000000;True;clear;com.google.javascript.jscomp.ClosureReverseAbstractInterpreter%getPreciser
ScopeKnowingConditionOutcome#0@26$(207,(208,223), paramType)
```
For this line:
* FAULT DETECTION: 1.0;
* Uncon: clear;
* DUA:`com.google.javascript.jscomp.ClosureReverseAbstractInterpreter%getPreciser
ScopeKnowingConditionOutcome#0@26$(207,(208,223), paramType)`

Regarding the DUA description:
* `com.google.javascript.jscomp.ClosureReverseAbstractInterpreter` is the class name;
* `%` is a delimiter
* `getPreciserScopeKnowingConditionOutcome` is the method's name
* `#` is a delimiter
* 0 is the method's identifier;
* `@` is a delimiter
* 26 is the DUA's identifier;
* `$` is a  delimiter
* `(207,(208,223), paramType)` is the DUA description where 207 is the line where the definition occurs, (208,223) is the edge where the use occurs, and `paramType` is the name of the variable object of the data flow.


### datacollection/subsumption-files

**subsumption-files** contains a sub-directory for each of the d4j's projects and each faulty version. They contain subsumption  information (DUA-DUA subsumption, DUA-edge subsumption and DUA-node subsumption), coverage requirements (DUAs, nodes, edges required), and mapping information (DUA to nodes and DUA  to edges) for every method of every class of the faulty. The subsumption, coverage, and mapping information are generated in the form of json files. We describe below the contents of each of the json files.

  File name       |      Content 
------------------| ----------------------
`<Class name>`.duas.json      | description of the DUAs belonging to each method of the class
`<Class name>`.sub.json      | this file lists for each method the leaves of the reduced subsumption graph


These data can optionally be removed after the execution of the scripts to generated FDP data. 

Additionally, we use **subsumption-files** sub-directories to save the node and edge coverage, generated from data flow coverage. These data is zipped and then moved to the **subsumption-files/reduce** directory.

### datacollection/satool

This directory contains the **satool** jar file and the libraries it uses. **satool** generates the json files of the **subsumption-files** directory.






