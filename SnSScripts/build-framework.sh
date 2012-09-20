#!/bin/zsh

SCRIPT_PATH="$PWD/`dirname $0`"
SCRIPT_MODE="manual"

TMP_WORK_PATH="/tmp/ios4me/ios4me.`date '+%m%d.%H%M%S'`"

LOGFILE="${TMP_WORK_PATH}/build.log"
LOGERR="${TMP_WORK_PATH}/build.err"

# ios4me specifics
IOS4ME_GIT_URL="git@github.com:smartnsoft/ios4me.git"
IOS4ME_GIT_BRANCH="master"
IOS4ME_GIT_CHECKOUT="n"
IOS4ME_GIT_PATH=""

IOS4ME_PROJECT_PATH=""
IOS4ME_PROJECT_WORKSPACE="SnSFramework.xcworkspace"
IOS4ME_PROJECT_SCHEME="ios4me\ \(Framework\)"
IOS4ME_PROJECT_CONFIGURATION="Release"
IOS4ME_VERSION="HEAD"

# global options
GLOBAL_BUILD_VERSION=""
GLOBAL_BUILD_NAME=""

GLOBAL_WORK_PATH=""
GLOBAL_WORK_DISTPATH=""
GLOBAL_WORK_FRAMEWORK_PATH=""
GLOBAL_WORK_FRAMEWORK_NAME="ios4me.framework"

GLOBAL_OPTION_INSTALL="y"
GLOBAL_OPTION_VERBOSE=

GLOBAL_OPTIONS=""

source ${SCRIPT_PATH}/log

parse_options()
{ 
  while [[ $1 = -* ]]; do
    case $1 in  
      -v|--version)       GLOBAL_BUILD_VERSION="$2"; shift;;
      -c|--configuration) IOS4ME_PROJECT_CONFIGURATION="$2"; shift;;
      -p|--project-path)  IOS4ME_GIT_PATH="$2"; shift;;
      -a|--auto)          SCRIPT_MODE="auto";;
      --verbose)          GLOBAL_OPTION_VERBOSE="y";;
      -h|--help)          print_usage;;
      *);;
      esac
      shift
    done
    
  ##################################
  # Computed variables
  GLOBAL_BUILD_NAME="${GLOBAL_PROJECT_NAME}-${GLOBAL_BUILD_VERSION}"
  GLOBAL_WORK_PATH="/tmp/${GLOBAL_BUILD_NAME}"  
  GLOBAL_WORK_FRAMEWORK_PATH="${GLOBAL_WORK_PATH}/build/Framework/${GLOBAL_WORK_FRAMEWORK_NAME}"

  if [[ $GLOBAL_OPTION_VERBOSE != "y" ]]; then
    GLOBAL_LOG_CMD=LogAndExecuteCommandHidden
  else
    GLOBAL_LOG_CMD=LogAndExecuteCommandTTY
  fi
}

ask_questions()
{
  if [[ ${SCRIPT_MODE} = "manual" ]]; then
    IOS4ME_GIT_CHECKOUT=`Ask "Should I perform a clone from github [y/n] ?" "$IOS4ME_GIT_CHECKOUT"`

    if [[ $IOS4ME_GIT_CHECKOUT = "n" ]]; then
      while [[ ! -d $IOS4ME_GIT_PATH ]]; do
        IOS4ME_GIT_PATH=`Ask "Where is your ios4me folder located ?"`
      done
    fi

    IOS4ME_VERSION=`Ask "Which version should I compile ? [dev/master/HEAD/tag# ...] ?" "$IOS4ME_VERSION"`

    GLOBAL_OPTION_INSTALL=`Ask "Should I install the framework when done compiling [y/n] ?" "$GLOBAL_OPTION_INSTALL"`

  fi
}

print_usage()
{
  echo "Mandatory:"
  echo "Optional:"
  echo "    -v --version:       [arg]  The version that will be built (ex. 1.0.0)."
  echo "                               If not version is provided a checkout from HEAD is performed"
  echo "    -c --configuration: [arg]  The configuration value (ex Debug/Release). [default: Release]"
  echo "    -f --tags-folder:   [arg]  The folder where tags will be written [default: https://svn2.smartnsoft.com/tags/"
  echo "    -h --help:                 Prints this help."
  echo "Example usage:"
  echo "./install-snsframework -v '1.0.1'      will checkout and install the SnS framework tagged with version 1.0.1"
  echo "./install-snsframework'                will checkout and install the SnS framework from head"
  echo ""
  
  exit 1
}

log_cmd()
{
  if [[ $GLOBAL_OPTION_VERBOSE != "y" ]]; then
    LogAndExecuteCommandHidden $*
  else
    LogAndExecuteCommandTTY $*
  fi
}

process_checks()
{
  if [[ ! -d "${IOS4ME_GIT_PATH}/.git" ]]; then
    LogError "${IOS4ME_GIT_PATH} doesn't seem to be a valid ios4me repository"
  fi

  IOS4ME_PROJECT_PATH="${IOS4ME_GIT_PATH}/SnSFramework/"
}

process_build()
{
  log_cmd rsync --exclude 'build' --exclude 'SnSTemplates' -r ${IOS4ME_GIT_PATH} ${TMP_WORK_PATH}

  log_cmd cd "${TMP_WORK_PATH}/ios4me"

  log_cmd git checkout "$IOS4ME_VERSION"

  log_cmd cd `find ${TMP_WORK_PATH} -name "${IOS4ME_PROJECT_WORKSPACE}"`/..

  log_cmd xcodebuild -workspace "$IOS4ME_PROJECT_WORKSPACE" -scheme "${IOS4ME_PROJECT_SCHEME}" -configuration "${IOS4ME_PROJECT_CONFIGURATION}"

  log_cmd find . -name ${GLOBAL_WORK_FRAMEWORK_NAME} -exec cp -r {} ${TMP_WORK_PATH} "\;"

  if [[ ${GLOBAL_OPTION_INSTALL} = "y" ]]; then
    copy_framework
  fi
}

create_folders()
{
  mkdir -p ${TMP_WORK_PATH}
}

copy_framework()
{

}

__main__()
{
  create_folders

  exec 1> >(tee -a ${LOGFILE})
  exec 2> >(tee -a ${LOGERR})

  LogBanner "Installing ios4me Framework  ---  Powered by Smart&Soft\nLogfile is $LOGFILE"

  parse_options $@

  ask_questions

  echo; Log "Processing Build"; echo

  process_checks
  process_build
}

##################################
# Main Command Start
__main__ $@