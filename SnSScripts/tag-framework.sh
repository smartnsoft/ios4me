#!/bin/zsh

#I4M_PATH_GIT="/path/to/ios4me"
I4M_PATH_GIT="/Volumes/Storage/Projects/ios4me"

if [[ ! -d ${I4M_PATH_GIT}/.git ]]; then
  echo "${I4M_PATH_GIT} doesn't seem to be a valid ios4me repository"
  exit 1
fi

echo $PROJECT_NAME
I4M_PRJ_VERSION=`grep "CFBundleVersion" $INFOPLIST_FILE -A 1 | grep -oE "\w+\.\w+"`
I4M_PRJ_TAG=`echo "${PROJECT_NAME}_${I4M_PRJ_VERSION}" | sed "s/\./-/g" |sed "s/\./-/g"`

echo $I4M_PRJ_TAG

cd $I4M_PATH_GIT
if [[ `git tag -l ${I4M_PRJ_TAG}` != "" ]]; then
  echo "Error - Tag ${I4M_PRJ_TAG} is already existing"
  exit 1
else
  git tag ${I4M_PRJ_TAG}
  git push --tags
fi