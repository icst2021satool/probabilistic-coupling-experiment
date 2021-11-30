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
	local coverage_zip_file="$root/coverage/$PROJECT_NAME/$COVERAGEZIP"
	local root=$(pwd)
  echo $coverage_zip_file
	if [ ! -f "$coverage_zip_file" ]
	then
		echo "Missing project $PROJECT_NAME's coverage data. End of story."
		echo
		exit 1
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
