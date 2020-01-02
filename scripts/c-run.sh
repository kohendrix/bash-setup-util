#!/bin/bash

# a runing output file helper

set -e

# help
if [[ $1 = "-h" || $1 = "--help" ]]
then
  echo "Usage: run.sh <project directory> <option>[-c|-clean]"
  echo "There must be main.cpp on the root of the project directory."
  exit 0
fi

# main
PROJECT_NAME=$1

# clean build option
if [[ $2 = "-c" || $2 = "--clean" ]]
then
  CLEAN=true
else
  CLEAN=false
fi

if ! [ -d $PWD/$PROJECT_NAME ]
then
  echo "No such project exists."
  exit 1
fi

if ! [ -f $PWD/$PROJECT_NAME/main.cpp ]
then
  echo "Missing the main file."
  exit 1
fi

if [[ ! -f $PWD/$PROJECT_NAME/build/main.out || $CLEAN = "true" ]]
then
  $HOME/util/scripts/gcc-compile.sh $PROJECT_NAME
fi

echo "Running $PROJECT_NAME"

$PWD/$PROJECT_NAME/build/main.out
