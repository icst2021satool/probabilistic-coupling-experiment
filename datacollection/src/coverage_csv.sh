#!/usr/bin/env bash
set -x

readonly PROJECT_NAME=$1
readonly VERSION=$2

function find_dua_cov()
{
local root=$(pwd)
cd $root/results/$project_name
echo "Project;Version;DUAcov" > "$PROJECT_NAME-duacov.csv"

for v in *b
do
cov=$(grep Covered $v/duacoverage.txt | awk -F: '{print $3}')
echo "$PROJECT_NAME;$v;$cov" >>  "$PROJECT_NAME-duacov.csv"
done

cd $root
}

function main() {
  pwd
	if [ -z "$PROJECT_NAME" ]
	then
	    echo "Missing project identifier. Possible values are:"
	    cat projects.d4j
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

	find_dua_cov $project_dir
}

main

