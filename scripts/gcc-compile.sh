#!/bin/bash

# just a build helper

set -ue

# help
if [[ $1 = "-h" || $1 = "--help" ]]
then
  echo "Usage: comp.sh <project directory>"
  echo "There must be main.cpp on the root of the project directory."
  exit 0
fi

# main
PROJECT_DIR=$1

if ! [ -d $PWD/$PROJECT_DIR ]
then
  echo "No such project exists."
  exit 1
fi

if ! [ -f $PWD/$PROJECT_DIR/main.cpp ]
then
  echo "Missing the main file."
  exit 1
fi

if ! [ -d $PWD/$PROJECT_DIR/build ]
then
  mkdir $PWD/$PROJECT_DIR/build 
fi

if [ -f $PWD/$PROJECT_DIR/main.cpp ]
then
  gcc $PWD/$PROJECT_DIR/main.cpp -o $PWD/$PROJECT_DIR/build/main.out
  echo "compiled $PROJECT_DIR/main.cpp"
fi