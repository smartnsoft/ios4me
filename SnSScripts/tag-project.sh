#!/bin/zsh

# no need to go further is configuration doesn't match AppStore
if [[ `echo ${CONFIGURATION}|grep -iE "(Release|Ad\s*Hoc|App\s*Store)"` == "" ]]; then
  echo "Skippng Tagging for Configuration [${CONFIGURATION}]"
  exit 0
fi



I4M_PRJ_VERSION=`grep "CFBundleShortVersionString" $INFOPLIST_FILE -A 1 | grep -oE "\w+(\.\w+)+"`
I4M_PRJ_TAG=`echo "${PRODUCT_NAME}_${I4M_PRJ_VERSION}" | sed "s/ /_/g" |sed "s/ /_/g"`

echo "Creating Tag : $I4M_PRJ_TAG for  $PRODUCT_NAME"

cd ${PROJECT_DIR}

if [[ `git tag -l ${I4M_PRJ_TAG}` != "" ]]; then
  echo "Error - Tag ${I4M_PRJ_TAG} is already existing"
  exit 1
else
  git tag ${I4M_PRJ_TAG}
  git push --tags
fi

