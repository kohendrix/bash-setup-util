#!/bin/bash

# this is just to create VS Code workspace settings.json

set -e

SETTINGS_FILE=".vscode/settings.json"

load_user_settings_prompt(){
  ORIGINAL_FILE=$1

  if [[ -f $ORIGINAL_FILE ]]
  then
    echo "VS Code user settings file found"
    while true
    do
      read -p "Do you wish to inherit the user settings into initial workspace setting? (y/n) : " yn
      case $yn in
          [Yy]*) sudo -k cp $ORIGINAL_FILE $SETTINGS_FILE; break;;
          [Nn]*) break;;
          * ) echo "Answer in y/n please."
      esac
    done
  fi
}

create_vscode_settings() {
  if ! [ -d ".vscode" ]
  then
    mkdir .vscode
  fi

  echo "{}" > $SETTINGS_FILE
  echo "settings.json created"

  if [[ $(uname) == "Darwin" ]]
  then
    load_user_settings_prompt $HOME/Library/ApplicationSupport/Code/User/settings.json
  elif [[ $(uname) == "Linux" ]]
  then
    load_user_settings_prompt $HOME/.config/Code/User/settings.json
  fi
}

# Main
if [[ -d ".vscode" && -f ".vscode/settings.json" ]]
then
  echo "VS Code workspace settings file already exists."
  exit 0
else
  create_vscode_settings
fi

echo "done"