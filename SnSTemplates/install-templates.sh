#!/bin/bash



BASE_TEMPLATE_ROOT_DIR_XCODE3="/Library/Application Support/Developer/Shared/Xcode"
BASE_TEMPLATE_ROOT_DIR_XCODE4="/Library/Developer/Xcode/Templates"
BASE_TEMPLATE_USER_DIR_XCODE3="$HOME/Library/Application Support/Developer/Shared/Xcode"
BASE_TEMPLATE_USER_DIR_XCODE4="$HOME/Library/Developer/Xcode/Templates"

BASE_FRAMEWORK_ROOT_DIR=`find /Developer/Platforms/ /Applications/Xcode*.app/ -name "*.sdk" -type d -maxdepth 8 |xargs -I {} echo "{}/System/Library/Frameworks"`
BASE_XCODE_VERSION="3 4"

SCRIPT_PATH="$PWD/`dirname $0`"
PROJECT_NAME="ios4me"
SMARTNSOFT_VER='SmartnSoftv1.0'
SMARTNSOFT_FRAMEWORKS_PATH="${SCRIPT_PATH}/Frameworks"
SMARTNSOFT_EXTRACT_PATH="${SCRIPT_PATH}/Frameworks/extracts"
SMARTNSOFT_TEMPLATE_NAME="${PROJECT_NAME} Application"

#BASE_TEMPLATE_DIR="./REP_install_template"
#BASE_TEMPLATE_USER_DIR="./REP_install_template"

force=
user_dir=
skip=

usage(){
cat << EOF
usage: $0 [options]
 
Install / update templates for ${SMARTNSOFT_VER}
 
OPTIONS:
   -f	force overwrite if directories exist
   -h	this help
   -s   skip the copy framework part
   -u	install in user's Library directory instead of global directory
   -x	Version of XCode to use. Could be 3 or 4 (default both)
EOF
}

#'
while getopts "fhuxs:" OPTION; do
	case "$OPTION" in
		f)
			force=1
			;;
		h)
			usage
			exit 0
			;;
		u)
			user_dir=1
			;;
		s)
			skip=1
			;;
		x)
			BASE_XCODE_VERSION=${OPTARG}
	esac
done

# Make sure only root can run our script
if [[ ! $user_dir  && "$(id -u)" != "0" ]]; then
	echo ""
	echo "Error: This script must be run as root in order to copy templates" 1>&2
	echo ""
	echo "Try running it with 'sudo', or with '-u' to install it only you:" 1>&2
	echo "   sudo $0" 1>&2
	echo "or:" 1>&2
	echo "   $0 -u" 1>&2   
exit 1
fi


copy_files(){
	fdst=`echo $1|sed "s/ /\\\ /g"`
	rsync -L -r --exclude=.svn "$fdst"/* "$2/"
	
}

check_dst_dir(){
	if [[ -d $DST_DIR ]];  then
		if [[ $force ]]; then
			echo "removing old libraries: ${DST_DIR}"
			rm -rf "$DST_DIR"
		else
			echo "templates already installed. To force a re-install use the '-f' parameter"
			exit 1
		fi
	fi
	
	echo "creating destination directory: $DST_DIR"
	mkdir -p "$DST_DIR"
}

copy_base_files(){
	echo ...copying SmartnSoft framework files
#	copy_files cocos2d "$LIBS_DIR"

	echo ...copying SmartnSoft framework dependency files
#	copy_files external/FontLabel "$LIBS_DIR"

	echo ...copying SmartnSoft framework files
#	copy_files CocosDenshion/CocosDenshion "$LIBS_DIR"

	echo ...copying SmartnSoft framework files
#	copy_files cocoslive "$LIBS_DIR"

	echo ...copying SmartnSoft framework dependency files
#	copy_files external/TouchJSON "$LIBS_DIR"

}

setup_colors()
{
	fg_bk=`tput setaf 0` #black
	fg_rd=`tput setaf 1` #red
	fg_gr=`tput setaf 2` #green
	#fg_lgr=
	fg_yw=`tput setaf 3` #yellow
	fg_bl=`tput setaf 4` #blue
	fg_pk=`tput setaf 5` #pink
	fg_cy=`tput setaf 6` #cyan
	fg_gy=`tput setaf 7` #gray
	fg_wh=`tput setaf 9` #white
	return 0
}

print_template_banner()
{
	Banner=$1
   	echo "${fg_cy}---------------------------------------------------------------------------" | tee -a $LOGFILE > /dev/tty
	echo "${fg_cy}$Banner" | tee -a $LOGFILE > /dev/tty
	echo "${fg_cy}---------------------------------------------------------------------------" | tee -a $LOGFILE > /dev/tty
	echo "${fg_wh}"
	return 0
	
	
}

print_ok()
{
	echo  "${fg_gr}---------------------------------------------------------------------------" | tee -a $LOGFILE > /dev/tty
	echo "${fg_gr}$1" | tee -a $LOGFILE > /dev/tty
	echo "${fg_gr}---------------------------------------------------------------------------" | tee -a $LOGFILE > /dev/tty
	echo "${fg_wh}"
	return 0
}

print_err()
{
	echo "${fg_rd}---------------------------------------------------------------------------" | tee -a $LOGFILE > /dev/tty
	echo "${fg_rd}$1" | tee -a $LOGFILE > /dev/tty
	echo "${fg_rd}---------------------------------------------------------------------------" | tee -a $LOGFILE > /dev/tty
	echo "${fg_rd}"
	return 0
}

template_dir(){
	xcode=$1
	templates_type=$2
	
	if [[ $user_dir &&  "${xcode}" == "3" ]]; 
	then
		TEMPLATE_DIR="${BASE_TEMPLATE_USER_DIR_XCODE3}/${templates_type}/${SMARTNSOFT_VER}/${SMARTNSOFT_TEMPLATE_NAME}"
	elif [[ $user_dir &&  "${xcode}" == "4" ]]; 
	then
		TEMPLATE_DIR="${BASE_TEMPLATE_USER_DIR_XCODE4}/${templates_type}/${SMARTNSOFT_VER}/"
	elif [[ "${xcode}" == "3" ]]; 
	then
		TEMPLATE_DIR="${BASE_TEMPLATE_ROOT_DIR_XCODE3}/${templates_type}/${SMARTNSOFT_VER}/${SMARTNSOFT_TEMPLATE_NAME}"
	elif [[ "${xcode}" == "4" ]]; 
	then
		TEMPLATE_DIR="${BASE_TEMPLATE_ROOT_DIR_XCODE4}/${templates_type}/${SMARTNSOFT_VER}/"
	else
		echo "Error: Unkown version of XCode Used: ${xcode}"
		exit
	fi
	
	echo "${TEMPLATE_DIR}"
}

#replace identifiers for XCode4 Templates
replace_identifier ()
{
	find "$1" -name "*.h" -exec grep $2 -l {} \; | xargs -I {} sed -i '' "s/$2/$3/g" "{}"
	find "$1" -name "*.m" -exec grep $2 -l {} \; | xargs -I {} sed -i '' "s/$2/$3/g" "{}"
}

copy_frameworks()
{
	if [[ "$skip" != "1" ]];
	then
		print_template_banner "Installing ${PROJECT_NAME}  External Frameworks"
		mkdir -p  ${SMARTNSOFT_EXTRACT_PATH}
		
		echo "List of Frameworks to Untar & Copy: "
		ls  ${SMARTNSOFT_FRAMEWORKS_PATH} | grep -i "tar.gz"
		
		find ${SMARTNSOFT_FRAMEWORKS_PATH} -name "*.tar.gz" -exec tar -xzf {} --directory ${SMARTNSOFT_EXTRACT_PATH} \;
			
		echo  ""
		for folder in ${BASE_FRAMEWORK_ROOT_DIR}
		do
			echo "... Coping Frameworks to $folder"
			copy_files "${SMARTNSOFT_EXTRACT_PATH}" "$folder"
		done
	
		print_ok "Done"
	fi
}

# copies project-based templates
copy_project_templates(){
	
	for xcode in ${BASE_XCODE_VERSION}
	do	
		print_template_banner "Installing ${PROJECT_NAME} Project Templates for XCode${xcode}"
			
		TEMPLATE_DIR=`template_dir $xcode "Project Templates"`
		
		DST_DIR="${TEMPLATE_DIR}"
		LIBS_DIR="$DST_DIR"libs
		
		
		check_dst_dir
		
		if [[ ! -d "$TEMPLATE_DIR" ]]; then
			echo "...creating ${PROJECT_NAME} template directory"
			echo ''
			mkdir -p "$TEMPLATE_DIR"
		fi

		

		echo ...copying template files
		copy_files "Project Templates/XCode${xcode}" "$DST_DIR"
		#rename_dest_folder "XCode${xcode}" "$DST_DIR"

		copy_base_files
	
		echo 'Remove Template Files directory'
		rm -rf "$DST_DIR""TemplatesFiles"
		
		print_ok "Done"
	done	
}

copy_file_templates(){
	
	for xcode in ${BASE_XCODE_VERSION}
	do	
		print_template_banner "Installing ${PROJECT_NAME} File Templates for XCode${xcode}..."
	
		TEMPLATE_DIR=`template_dir $xcode "File Templates"`
		DST_DIR="$TEMPLATE_DIR"
		
		check_dst_dir
	

		if [[ ! -d "$TEMPLATE_DIR" ]]; then
			echo "creating ${PROJECT_NAME} template directory"
			mkdir -p "$TEMPLATE_DIR"
		fi
	
	
		copy_files "File Templates/XCode${xcode}/SnSViewController class" "$DST_DIR"
		
		#replace identifiers for compatiblity with XCode4
		if [ "$xcode" == "4" ]
		then
			replace_identifier "$DST_DIR" "«OPTIONALHEADERIMPORTLINE»" "#import \"___FILEBASENAME___.h\""
			replace_identifier "$DST_DIR" "«PROJECTNAME»" "___PROJECTNAME___"
			replace_identifier "$DST_DIR" "«FILENAME»" "___FILENAME___"
			replace_identifier "$DST_DIR" "«FILEBASENAMEASIDENTIFIER»" "___FILEBASENAMEASIDENTIFIER___"
		fi
		
		print_ok "Done"
	done
	
	
}

build_framework ()
{
	print_template_banner "Building ${PROJECT_NAME} Framework"
	
	log_path="${SCRIPT_PATH}/log.txt"
	log_err="${SCRIPT_PATH}/log.err"
	
	cd "${SCRIPT_PATH}/../SnSFramework"
	echo '... Building: xcodebuild -workspace "SnSFramework.xcworkspace" -scheme "ios4me (Framework)" -configuration "Debug"'
	sudo -u $SUDO_USER xcodebuild -workspace "SnSFramework.xcworkspace" -scheme "ios4me (Framework)" -configuration "Debug" > ${log_path} 2>${log_err}
	
	if [ $? -gt 0 ]
	then
		build_dir=`grep "setenv BUILD_DIR" ${log_path} | grep -oE "\".+\""`
		errors="`grep '' ${log_err}`\n`grep 'error:' ${log_path}`"
		find "${build_dir}" -exec chown $SUDO_USER {}  \; 2>>${log_err}
		print_err "Failed to execute: xcodebuild -target 'ios4me (Framework)' -configuration 'Debug' \n${errors}"
		# exit
	fi
	
	cd ${SCRIPT_PATH}
	
	build_dir=`grep "setenv BUILD_DIR" ${log_path} | grep -oE "\".+\""|sed "s/\"//g"`
	snsframework_path=`grep -i 'The framework was built at' ${log_path}|grep -oE '/.*\.framework'`
	
	if [ "${snsframework_path}" = "" ]
	then
		print_err "Framework path could not be determined"
		exit
	fi
	
	#Copy SnSFramework
	cp -rf $snsframework_path ${SMARTNSOFT_EXTRACT_PATH}
	for folder in ${BASE_FRAMEWORK_ROOT_DIR}
	do
		echo "... Coping ios4me.framework to $folder"
		copy_files "${SMARTNSOFT_EXTRACT_PATH}" "$folder"
	done
	
	#change back ownership to previous owner if in sudo mode
	find "${build_dir}" -exec chown $SUDO_USER {}  \; 2>>${log_err}
	
	#clean up
	rm -rf $log_path
	rm -rf $log_err
	
	print_ok "Done"
	
}

__main__ ()
{
	setup_colors

	print_template_banner "${PROJECT_NAME} Project Template Installer"
	
	copy_frameworks

	copy_project_templates

	copy_file_templates
	
	build_framework
		
}

__main__

