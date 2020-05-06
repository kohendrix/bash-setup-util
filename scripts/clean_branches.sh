#!/bin/bash

set -e

# functions ->
prune_prompt(){
    echo "Prunable Branches ======="
    PRUNABLES=`git remote prune origin --dry-run | grep 'origin/.*' | awk '{ print $4 }'`
    
    if [ -z "$PRUNABLES" ]
    then
        echo "No branch is prunable"
    else
        for BRANCH in $PRUNABLES
        do
            echo $BRANCH
        done
        echo
         # prompt
        while true
        do
            read -p "Do you wish to prune all these branches? (y/n) : " yn
            case $yn in
                [Yy]* ) echo "Pruning..."; git remote prune origin; break;;
                [Nn]* ) break;;
                * ) echo "Answer in a/s/n please."
            esac
        done
    fi
}

delete_each_prompt(){
    BRANCH=$1
    if [ -z "$BRANCH" ]
    then
        echo "No branch to delete."
    else
        while true
        do
            read -p "Do you wish to delete [$BRANCH] ? (y/n) : " yn
            case $yn in
                [Yy]* ) git branch -d $BRANCH; break;;
                [Nn]* ) break;;
                * ) echo "Answer in y/n please."
            esac
        done
    fi
}

delete_locals_origin_gone_prompt(){
    echo "Local branches with origin gone ======="
    BRANCHES=`git branch -vv | grep 'origin/.*: gone]' | awk '{ print $1 }'`

    if [ -z "$BRANCHES" ]
    then
        echo "No local branch with origin gone."
    else
        for BRANCH in $BRANCHES
        do
            echo $BRANCH
        done
        echo
        while true
        do
            read -p "Do you wish to delete all these branches, some, or nothing? (a/s/n) : " yn
            case $yn in
                [Aa]* ) echo "Deleting all..."; echo $BRANCHES | xargs git branch -d ; break;;
                [Ss]* ) 
                    for BRANCH in $BRANCHES
                    do 
                        delete_each_prompt $BRANCH
                    done; break;;
                [Nn]* ) break;;
                * ) echo "Answer in a/s/n please."
            esac
        done
    fi
}

delete_locals_with_no_origin_prompt(){
    echo "Local branches without origin ======="
    BRANCHES=`git branch -vv | grep -v 'origin/' | awk '{ print $1 }'`

    if [ -z "$BRANCHES" ]
    then
        echo "No local branch without origin."
    else
        for BRANCH in $BRANCHES
        do
            echo $BRANCH
        done
        echo
        while true
        do
            read -p "Do you wish to delete all these branches, some, or nothing? (a/s/n) : " yn
            case $yn in
                [Aa]* ) echo "Deleting all..."; echo $BRANCHES | xargs git branch -d ; break;;
                [Ss]* ) 
                    for BRANCH in $BRANCHES
                    do 
                        delete_each_prompt $BRANCH
                    done; break;;
                [Nn]* ) break;;
                * ) echo "Answer in a/s/n please."
            esac
        done
    fi
}
# -> functions end

# process start here
echo "CLEAN UP BRANCHES\n"
git checkout master
git fetch --all

# local origin/ branches
prune_prompt
echo

# local branches
delete_locals_origin_gone_prompt
echo

delete_locals_with_no_origin_prompt
