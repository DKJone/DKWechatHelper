#!/bin/bash

# Usage
# Must be an absolute path

# ./quick-resign.sh [insert] "origin.ipa path"  "resign.ipa path"

INSERT_DYLIB=NO
INPUT_PATH=$1
OUTPUT_PATH=$2

if [[ $1 == "insert" ]];then
	INSERT_DYLIB=YES
	INPUT_PATH=$2
	OUTPUT_PATH=$3
fi

if [[ ! $OUTPUT_PATH ]];then
	OUTPUT_PATH=$PWD
fi

cp -rf $INPUT_PATH ../TargetApp/
cd ../../
xcodebuild MONKEYDEV_INSERT_DYLIB=$INSERT_DYLIB | xcpretty
cd LatestBuild
./createIPA.command
cp -rf Target.ipa $OUTPUT_PATH
exit 0