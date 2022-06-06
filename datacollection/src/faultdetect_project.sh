#!/usr/bin/env bash
#set -x
readonly NOCOLOR="\033[0m"
readonly GREEN="\033[0;32m"
readonly RED="\033[0;31m"
readonly YELLOW="\033[1;33m"

readonly PROJECT_NAME=$1
readonly START=$2
readonly END=$3
readonly COVERAGEZIP=$4
readonly DATAGEN=$5
readonly COPYFAULTYSRC=$6
readonly CLEANUP=$7

function faultdetect_project() {
	local project_dir=$1
	local d4j_projects="d4jprojects"
	local coveragedir=$root/coverage/$PROJECT_NAME
	local coverage_zip_file="$COVERAGEZIP"
	local root=$(pwd)

	if [ ! -f "$coveragedir/$coverage_zip_file" ]
	then
		echo "Missing project $PROJECT_NAME's coverage data. Trying to fetch it."
		mkdir -p $coveragedir

		if [ ! -d "$coveragedir" ]
		then
		echo "$coveragedir directory does not exit. End of story."
		exit 1
		fi	

  		cd $coveragedir
  		wget http://143.107.58.177/${coverage_zip_file} 

  		if [ ! -f "$coveragedir/$coverage_zip_file" ]
 		then
		echo "$coveragedir/$coverage_zip_file does not exit. Couldn't get it remotely. End of story."
		exit 1
		fi

		cd $root
	fi


	for ((i = $START ; i <= $END ; i++));
	do
	src/datafilegen.sh $PROJECT_NAME ${i}b $COVERAGEZIP $DATAGEN $COPYFAULTYSRC $CLEANUP
	done

}

function main() {
  local root=$(pwd)

	if [ -z "$PROJECT_NAME" ]
	then
	    echo "Missing project identifier. Possible values are:"
	    cat projects.d4j
	    echo
	    exit 1
	fi

	if [ -z "$START" ]
	then
	    echo "Missing project's start version. Possible values are:"
	    cat versions.d4j
	    echo
	    exit 1
	fi

	if [ -z "$END" ]
	then
	    echo "Missing project's end version. Possible values are:"
	    cat versions.d4j
	    echo
	    exit 1
	fi

	if [ -z "$COVERAGEZIP" ]
	then
			echo "Missing project's zip file name."
			cat versions.d4j
			echo
			exit 1
	fi

	local project_dir=$(cat projects.d4j | grep $PROJECT_NAME | sed "s/$PROJECT_NAME//g" | xargs)

	if [ -z "$project_dir" ]
	then
		echo "Wrong project identifier. Possible values are:"
		cat projects.d4j
		echo
		exit 1
	fi

	faultdetect_project $project_dir
}

main
