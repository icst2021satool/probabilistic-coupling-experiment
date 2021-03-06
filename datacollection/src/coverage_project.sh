#!/usr/bin/env bash
#set -x
readonly NOCOLOR="\033[0m"
readonly GREEN="\033[0;32m"
readonly RED="\033[0;31m"
readonly YELLOW="\033[1;33m"

readonly PROJECT_NAME=$1
readonly VERSION=$2
readonly ZIPFILE=$3

function assert_project() {
	local root=$(pwd)
	local project_dir=$1
	local cov_projects="${root}/coverage/${PROJECT_NAME}"
	local project_path="$cov_projects/$project_dir/${VERSION}"

	# check where is the badua report

	if [ -f "${project_path}/jaguar/badua_report.xml" ]
	then
	    echo "Ba-dua report is in the right place."
	else
	    echo "Trying to fetch Ba-dua."
	    if [ -f "${project_path}/ba-dua.xml" ]
    	    then
	      cp "${project_path}/ba-dua.xml" "${project_path}/jaguar/badua_report.xml" 
	    else
	      echo "Ba-dua report: couldn'd find it."
	    fi
	fi


	# run assert_jaguar.py
	echo -e "[${PROJECT_NAME} ${VERSION}] Jaguar DUA coverage"
	${root}/src/coverage_jaguar.py ${PROJECT_NAME} ${VERSION} ${project_path}/jaguar

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
  echo "$coveragedir/$zipfile does not exist. Try to get it remotely"
  mkdir -p $coveragedir
  cd $coveragedir
  wget http://143.107.58.177/${zipfile}

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

function cleanup() {
  #statements
  local root=$1
  local coveragedir="$1/coverage/$PROJECT_NAME"
  local project_dir=$2
  local covfilesdir="$project_dir/$VERSION"

  cd $coveragedir

  if [ -d "$covfilesdir" ]
  then
    rm -rf $covfilesdir
  fi
  cd $root
}

function main() {
  	pwd
	local root=$(pwd)
	if [ -z "$PROJECT_NAME" ]
	then
	    echo "Missing project identifier. Possible values are:"
	    cat projects.d4j
	    echo
	    exit 1
	fi

	if [ -z "$VERSION" ]
	then
	    echo "Missing project version. Possible values are (append 'b' for buggy and 'f' for fixed):"
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
	coverage_expansion $root $PROJECT_NAME $project_dir $ZIPFILE
	assert_project $project_dir
}

main

