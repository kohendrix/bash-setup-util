#!/bin/bash

# requires jq installed

# check if it's a git directory
if ! [ -d .git ]
then
  echo "This is not a git directory."
  exit 1
fi


CONFIG_PATH=$HOME/bash-setup-util/config/git_users.json

# check file existence
if ! [ -f $CONFIG_PATH ]
then
  echo "Git users config file does not exist at a path => $CONFIG_PATH"
  exit 1
fi

# argument check
if [ -z $1 ]
then
  echo "Please specify the username."
  exit 1
fi

USER_NAME=$1
CONFIG_JSON=$(cat $CONFIG_PATH | jq ".$USER_NAME" -e)

# data check
if ! [ $? = 0 ]
then
  echo "Username $USER_NAME does not exist on config."
  exit 1
fi

# properties check
GIT_USER_NAME=$(cat $CONFIG_PATH | jq ".$USER_NAME.name" -re)
if ! [ $? = 0 ]
then
  echo "'name' property is missing on config."
  exit 1
fi

GIT_USER_EMAIL=$(cat $CONFIG_PATH | jq ".$USER_NAME.email" -re)
if ! [ $? = 0 ]
then
  echo "'email' property is missing on config."
  exit 1
fi

# actually set the git config here
git config user.name $GIT_USER_NAME
git config user.email $GIT_USER_EMAIL

echo "Successfully set git user with 'name' $GIT_USER_NAME, 'email' $GIT_USER_EMAIL"
echo "\ngit config"
cat .git/config
