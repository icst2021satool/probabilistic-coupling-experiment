#!/usr/bin/env bash
set -x
readonly NOCOLOR="\033[0m"
readonly GREEN="\033[0;32m"
readonly RED="\033[0;31m"
readonly YELLOW="\033"

readonly PROJECT_NAME=$1
readonly VERSION=$2
readonly ZIPFILE=$3
readonly DATAGEN=$4
readonly COPYFAULTYSRC=$5
readonly CLEANUP=$6

function install_project() {
local project_dir=$1
local version=$VERSION
local d4j_projects="d4jprojects"
local project_path="$d4j_projects/$project_dir/$version"
local root=$(pwd)

# Uncomment and set the location and variables for running defects4j

export PATH=$PATH:/home/chaim/tools/defects4j/framework/bin
export D4J_HOME=/home/chaim/tools/defects4j

# create d4j projects folder
mkdir -p $d4j_projects
mkdir -p "$d4j_projects/$project_dir"
mkdir -p "$d4j_projects/$project_dir/$version"

# checkout project version
echo -e "${YELLOW}[${PROJECT_NAME} ${VERSION}] checkout${NOCOLOR}"
defects4j checkout -p $PROJECT_NAME -v $VERSION -w $project_path

# compile project
cd $project_path
echo -e "${YELLOW}[${PROJECT_NAME} ${VERSION}] compiling${NOCOLOR}"
defects4j compile

# run tests
echo -e "${YELLOW}[${PROJECT_NAME} ${VERSION}] running tests${NOCOLOR}"
defects4j test
echo -e "${GREEN}[${PROJECT_NAME} ${VERSION}] checkout done${NOCOLOR}"

# back to root folder
cd $root
}

function coverage_expansion() {
local root=$1
local coveragedir="$1/coverage/$2"
local project_dir=$3
local zipfile=$ZIPFILE # program_dir

if [ ! -f "$coveragedir/$zipfile" ]
then
  echo "$coveragedir/$zipfile does not exit. Try to get it remotely"
  mkdir -p $coveragedir
  cd $coveragedir
  wget --no-passive ftp://143.107.58.177/pub/${zipfile} 

  if [ ! -f "$coveragedir/$zipfile" ]
  then
  echo "$coveragedir/$zipfile does not exit. Couldn't get it remotely. End of story."
  exit
  fi
fi

cd $coveragedir

local filesdir="$project_dir/$VERSION/*"
rm -rf $filesdir

if [ -d "$project_dir/$VERSION" ]
then
 rmdir "$project_dir/$VERSION"
fi	

unzip $zipfile $filesdir
cd $root
}

function compare_files() {
#statements
local root=$1
local project_dir=$2
local differentclasses=`src/comparisonv2.py  $root/coverage/$PROJECT_NAME/$project_dir/$VERSION $root/subsumption-files/$PROJECT_NAME/reduce/$VERSION | grep NOK`
	
echo "Different classes: $differentclasses"
if [ ! -z "$differentclasses" ]
then
	echo "There are different classes. End of story"
	exit
fi
}

function safilesgen() {
  #statements

  local subsumptiondir="$1/subsumption-files"
  local satooldir="$1/satool"
  local satool=safilestool.jar
  #local satool=asmexplore-1.0-SNAPSHOT.jar
  local srcdir=$1/d4jprojects/$2
  local destdir=$subsumptiondir/$PROJECT_NAME/reduce/$VERSION

  if [ ! -d "$subsumptiondir/$PROJECT_NAME" ]
  then
    mkdir "$subsumptiondir/$PROJECT_NAME"
  fi

  if [ ! -d "$subsumptiondir/$PROJECT_NAME/reduce" ]
  then
    mkdir "$subsumptiondir/$PROJECT_NAME/reduce"
  fi

  if [ ! -d "$subsumptiondir/$PROJECT_NAME/reduce/$VERSION" ]
  then
    mkdir "$subsumptiondir/$PROJECT_NAME/reduce/$VERSION"
  fi

  #rm -f $destdir/*.json $destdir/*.log

  for v in  $destdir/*.json
  do
  	rm -f $v
  done

  for v in  $destdir/*.log
  do
  	rm -f $v
  done

  time java -cp $satooldir/$satool:$satooldir/dependency/* \
      br.usp.each.saeg.subsumption.cli.Main reduce  -src $srcdir -dest $destdir  >& $destdir/$PROJECT_NAME-$VERSION.log
  time java -cp $satooldir/$satool:$satooldir/dependency/* \
      br.usp.each.saeg.subsumption.cli.Main edgesubsume  -src $srcdir -dest $destdir  >& $destdir/$PROJECT_NAME-$VERSION-edge.log
  time java -cp $satooldir/$satool:$satooldir/dependency/* \
      br.usp.each.saeg.subsumption.cli.Main nodesubsume  -src $srcdir -dest $destdir  >& $destdir/$PROJECT_NAME-$VERSION-node.log
}

function find_exec_dir() {
  local project=$PROJECT_NAME
  local version=$VERSION
  local projectdir=$1
  local timetarget="1b 2b 3b 4b 5b 6b 7b 8b 9b 10b 11b"
  SRCDIR="$projectdir/$version/target/classes"
  JAVADIR="$projectdir/$version/src"

  if test $project == "Chart"
  then
     SRCDIR=$projectdir/$version/build
	 JAVADIR="$projectdir/$version/source"
  fi

  if test $project == "Cli"
  then
	 JAVADIR=$JAVADIR/java
  fi

  if test $project == "Closure"
  then
	 SRCDIR=$projectdir/$version/build/classes
  fi

  if test $project == "Codec"
  then
     JAVADIR=$JAVADIR/java
  fi

  if test $project == "Collections"
  then
     JAVADIR=$JAVADIR/main/java
  fi

  if test $project == "Compress"
  then
	 JAVADIR=$JAVADIR/main/java
  fi

  if test $project == "Csv"
  then
     JAVADIR=$JAVADIR/main/java
  fi

  if test $project == "Gson"
  then
     JAVADIR=$projectdir/$version/gson/src/main/java
  fi

  if test $project == "JacksonCore"
  then
     JAVADIR=$JAVADIR/main/java
  fi

  if test $project == "JacksonDatabind"
  then
	 JAVADIR=$JAVADIR/main/java
  fi

  if test $project == "JacksonXml"
  then
	 JAVADIR=$JAVADIR/main/java
  fi

  if test $project == "Jsoup"
  then
	 JAVADIR=$JAVADIR/main/java
  fi

  if test $project == "JxPath"
  then
	 JAVADIR=$JAVADIR/java
  fi

  if test $project == "Lang"
  then
	 JAVADIR=$JAVADIR/main/java
  fi

  if test $project == "Math"
  then
	 JAVADIR=$JAVADIR/main/java
  fi

  if test $project == "Mockito"
  then
     SRCDIR=$projectdir/$version/build/classes/main
  fi

  if test $project == "Time"
  then
	 JAVADIR=$JAVADIR/main/java
	 targetversions=$(echo $timetarget | grep $version)
	 if [ -z "$targetversions" ]
	 then   # empty means classes are in the build directory
     		SRCDIR=$projectdir/$version/build/classes
	 fi
  fi

  if test $project == "Weka"
  then
    SRCDIR=$projectdir/weka/build/classes
	 JAVADIR=$projectdir/weka/src/main/java
  fi

  echo $SRCDIR
  echo $JAVADIR
}

function datafile_calculation {
	#statements
	local root=$1
	local project_dir=$2

  if [ ! -d "$root/results/$PROJECT_NAME/$VERSION" ]
	then
		mkdir "$root/results/$PROJECT_NAME/$VERSION"
	else
		rm -f "$root/results/$PROJECT_NAME/$VERSION/*.csv"
		rm -f "$root/results/$PROJECT_NAME/$VERSION/*.txt"
	fi

  if [ "$DATAGEN" = "-fdp" ]; then
    rm -f $root/results/$PROJECT_NAME/$VERSION/fdp-$PROJECT_NAME-$VERSION.csv
    rm -f $root/results/$PROJECT_NAME/$VERSION/fdp-$PROJECT_NAME-$VERSION.json
    $root/src/faultdetectv3.py $root/coverage/$PROJECT_NAME/$project_dir/$VERSION $root/subsumption-files/$PROJECT_NAME $VERSION \
	             -faultdetect -duas -all -csv $root/results/$PROJECT_NAME/$VERSION/fdp-$PROJECT_NAME-$VERSION.csv
  fi
	
  if [ "$DATAGEN" = "-ochiai" ]; then
    rm -f $root/results/$PROJECT_NAME/$VERSION/ochiai-$PROJECT_NAME-$VERSION.csv
    rm -f $root/results/$PROJECT_NAME/$VERSION/ochiai-$PROJECT_NAME-$VERSION.json
    $root/src/faultdetectv3.py $root/coverage/$PROJECT_NAME/$project_dir/$VERSION $root/subsumption-files/$PROJECT_NAME $VERSION \
						 	 -ochiai -duas -all -csv $root/results/$PROJECT_NAME/$VERSION/ochiai-$PROJECT_NAME-$VERSION.csv
  fi

  if [ "$DATAGEN" = "-subsumption" ]; then
    echo "Saving subsumption files for $PROJECT_NAME-$VERSION"

  if [ -f "$root/subsumption-files/$PROJECT_NAME/$PROJECT_NAME-subsumption-json.tar.gz" ]
  then
    gunzip "$root/subsumption-files/$PROJECT_NAME/$PROJECT_NAME-subsumption-json.tar.gz"
  fi
  cd $root/subsumption-files/$PROJECT_NAME/reduce
  tar rvf $root/subsumption-files/$PROJECT_NAME/$PROJECT_NAME-subsumption-json.tar $VERSION/*
  gzip $root/subsumption-files/$PROJECT_NAME/$PROJECT_NAME-subsumption-json.tar
  rm -f $root/subsumption-files/$PROJECT_NAME/reduce/$VERSION/*
  cd $root
  fi

  leanversion=$(echo $VERSION | sed "s/b//g" | xargs)
  $root/src/get_buggy_lines.sh $PROJECT_NAME $leanversion $root/results/$PROJECT_NAME/$VERSION

}

function copy_faulty_files(){
  local project=$PROJECT_NAME
  local version=$VERSION
  local root=$1
  local projectdir=$2
  local leanversion=$(echo $VERSION | sed "s/b//g" | xargs)
  local javadir="$root/d4jprojects/$JAVADIR"
  local coveragedir="$root/coverage/$PROJECT_NAME/$project_dir/$VERSION"
  local resultsdir=$root/results/$project/$version
  local buggylinesfile=$resultsdir/$project-$leanversion.buggy.lines
  local subsumptiondir="$1/subsumption-files/$PROJECT_NAME/reduce/$VERSION"

	if [ !  $buggylinesfile ]
	then
		echo "There is not file $buggylinesfile"
	else
	  files=$(cat $buggylinesfile | awk -F# '{ print $1 }')
		echo $files
		for f in $files
		do
			echo "$root/d4jprojects/$JAVADIR/$f"
			cp "$root/d4jprojects/$JAVADIR/$f" $resultsdir
		done

    # copy json files for analysis
		for f in $files
		do
			clazz=$(echo $f | sed "s/\//\./g" | sed "s/\.java//g")
      if [ "$subsumptiondir/$clazz.sub.json" ]
      then
        cp "$subsumptiondir/$clazz.sub.json" $resultsdir
      else
        echo "There is not file $clazz.sub.json"
      fi
      if [ "$subsumptiondir/$clazz.sub.json" ]
      then
        cp "$subsumptiondir/$clazz.duas.json" $resultsdir
      else
        echo "There is not file $clazz.duas.json"
      fi
		done

	fi

	cp -f "$coveragedir/tests.out" $resultsdir
	cp -f "$coveragedir/jaguar.out" $resultsdir
}

function cleanup() {
	#statements
	local root=$1
	local coveragedir="$1/coverage/$PROJECT_NAME"
	local objdir="$1/d4jprojects/$2"
	local project_dir=$2
	local zipfile="$project_dir.zip" # program_dir
	local covfilesdir="$project_dir/$VERSION"
	local objfilesdir="$objdir/$VERSION"
  local subsumptiondir="$1/subsumption-files/$PROJECT_NAME/reduce/$VERSION"

	cd $objdir

	if [ -d "$VERSION" ]
	then
		rm -rf $objfilesdir
	fi

	cd $coveragedir

	if [ -d "$covfilesdir" ]
	then
		rm -rf $covfilesdir
	fi

	cd $subsumptiondir

	if [ -d "$subsumptiondir" ]
	then
		rm -rf $subsumptiondir
	fi

	cd $root
}

function echo_parameters() {
    echo "Wrong number of parameters"
    echo "This script supposes it is run at datacolletion directory using src/<script name> command"
    echo "arg[1] Name of the project (e.g., Chart, Math)"
    echo "arg[2] Version (e.g., 2b)"
    echo "arg[3] Zip file with jaguar DUA data."
    echo "arg[4] Data file to be generated (e.g., fdp, ochiai, edgematrix, nodematrix)"
    echo "arg[5] -copy: Copy faulty classes"
    echo "arg[6] -cleanup: clean up the static and dynamic data (e.g., json, matrix, spectra files)     used to generate data file "
  }

function main() {

  pwd
	if [ -z "$PROJECT_NAME" ]
	then
      echo_parameters
	    echo "Missing project identifier. Possible values are:"
	    cat projects.d4j
	    echo
	    exit 1
	fi

	if [ -z "$VERSION" ]
	then
      echo_parameters
	    echo "Missing project version. Possible values are (append 'b' for buggy and 'f' for fixed):"
	    cat versions.d4j
	    echo
	    exit 1
	fi

	local project_dir=$(cat projects.d4j | grep $PROJECT_NAME | sed "s/$PROJECT_NAME//g" | xargs)

	if [ -z "$project_dir" ]
	then
    echo_parameters
		echo "Wrong project identifier. Possible values are:"
		cat projects.d4j
		echo
		exit 1
	fi


  local root=$(pwd)

  install_project $project_dir
  find_exec_dir $project_dir
  safilesgen $root $SRCDIR

  # To generate subsumption files (-subfiles), we don't need coverage data

  if test $DATAGEN != "-subfiles" 
  then
     echo "Expand coverage data"
     coverage_expansion $root $PROJECT_NAME $project_dir $ZIPFILE
     compare_files $root $project_dir
  else
     echo "Don't expand coverage data"
  fi

  datafile_calculation $root $project_dir

  if [ -z "$COPYFAULTYSRC" ]
  then
    echo "Not copying faulty classes."
  else
     if test $COPYFAULTYSRC == "-copy"
  	then
		copy_faulty_files $root $PROJECT_NAME $project_dir
	else
                echo "Not copying faulty classes."
     fi
  fi
  if [ -z "$CLEANUP" ]
	then
    echo "Not cleaning up files to generate data."
  else
     if test $CLEANUP == "-cleanup"
     then
	cleanup $root $project_dir
     else
    echo "Not cleaning up files to generate data."
     fi
  fi
  
}
main
