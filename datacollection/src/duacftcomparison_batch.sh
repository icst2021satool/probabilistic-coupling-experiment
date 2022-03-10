#!/usr/bin/env bash
set -x
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

function prepare_and_run_project_file() {
	local project_dir=$1
	local subsumption_dir="$root/subsumption-files/$PROJECT_NAME"
	local results_dir="$root/results/$PROJECT_NAME"
	local coverage_zip_file="$root/coverage/$PROJECT_NAME/$COVERAGEZIP"
	local root=$(pwd)

  	echo $coverage_zip_file

	if [ ! -d "$subsumption_dir" ]
	then
		echo "Missing project $PROJECT_NAME's subsumption directory. End of story."
		echo
		exit 1
	fi


	if [ ! -d "$results_dir" ]
	then
		echo "Missing project $PROJECT_NAME's results directory. End of story."
		echo
		exit 1
	fi

	rm -rf $subsumption_dir/reduce
	local filesdir="$project_dir/*"
	
	for ((i = $START ; i <= $END ; i++));
	do
		cd $root

		# dummy.zip is just to fill up a required parameter

		touch coverage/$PROJECT_NAME/dummy.zip
		src/datafilegen.sh $PROJECT_NAME ${i}b dummy.zip -subfiles -ncopy -ncleanup

		cd $root

		src/duacftcomparison.py $root $PROJECT_NAME ${i}b  -fdp -json $results_dir/${i}b/fdp-dua-cft-comparison-${i}b.json

		rm -rf $subsumption_dir/reduce/${i}b
		rm coverage/$PROJECT_NAME/dummy.zip
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

	local project_dir=$(cat projects.d4j | grep $PROJECT_NAME | sed "s/$PROJECT_NAME//g" | xargs)

	if [ -z "$project_dir" ]
	then
		echo "Wrong project identifier. Possible values are:"
		cat projects.d4j
		echo
		exit 1
	fi

	prepare_and_run_project_file $project_dir
}

main
