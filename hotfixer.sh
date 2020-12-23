#### Constants

# set current working directory
	cwd=$(pwd)
# Exceptions
	set -e

# Check if 7z is installed
	if ! archiverLocation="$(type -p "7z")" || [[ -z $archiverLocation ]]; then
 		echo -e "\e[101m7z is not installed. Please install 7z and try again.\e[0m"
	fi

#### Functions
test(){
    echo -e "\e[44mCreating folders for bundle backup if they don't exist\e[0m"
}

dl72hf(){
###For getting the password for private-ee


#Downloads Portal Base
# Clean out old copy
	echo -e "\e[44mCleaning out old extracted binaries/folders\e[0m"
	rm -rf $cwd/bundles/hotfixer


# Create directories that will be used
	echo -e "\e[44mCreating folders for bundle backup if they don't exist\e[0m"
	mkdir -p bundles/hotfixer
	#mkdir -p hotfixer

# Check download it
  	echo -e "\e[44mDownloading the master snapshot if its updated\e[0m"
  	read -p 'Please specify download link for portal: ' portaldl
	wget -c -N --user=brittney.nguyen --ask-password $portaldl -P $cwd/bundles/hotfixer
	7z x $cwd/bundles/hotfixer/*.7z -O$cwd/bundles/hotfixer
	echo -e "\e[44mDone downloading or checking\e[0m"

	echo -e 'Current directory: ' $cwd
	
	cd $cwd/bundles/hotfixer/*/
	echo -e 'Changed directory to liferay.home'
	echo -e 'Current directory 2: ' $(pwd)
	
	 # Remove patching tool folder
 	echo -e "\e[44mRemoving current patching tool folder\e[0m"
	rm -rf $cwd/bundles/hotfixer/*/patching-tool
	read -p 'Please specify download link for patching tool: ' patchdl
 	wget -c -N --user=brittney.nguyen --ask-password $patchdl -P $cwd/bundles/hotfixer/*/
 	unzip $cwd/bundles/hotfixer/*/*.zip -d $cwd/bundles/hotfixer/*/
 	echo -e "\e[44mDone downloading or checking patching tool\e[0m"
 	echo -e 'Current directory 3: ' $(pwd)
 	cd $cwd/bundles/hotfixer/*/patching-tool
 	echo -e 'changing into patching tool directory..' $(pwd)
 	
 	# Navigate into patching tool and run commands to install patch
	echo -e "\e[44mRunning auto-discovery\e[0m"
	$cwd/bundles/hotfixer/*/patching-tool/patching-tool.sh auto-discovery 
	echo -e "\e[44mDownloading the hotfix\e[0m"
	read -p 'Please specify download link for the fixpack: ' fixpackdl
	wget -c -N --user=brittney.nguyen --ask-password $fixpackdl -P $cwd/bundles/hotfixer/*/patching-tool/patches
	read -p 'Please specify download link for the hotfix: ' hotfixdl
	wget -c -N --user=brittney.nguyen --ask-password $hotfixdl -P $cwd/bundles/hotfixer/*/patching-tool/patches
	$cwd/bundles/hotfixer/*/patching-tool/patching-tool.sh install 
	


}

#### Help documentation

usage ()
{
	cat <<HELP_USAGE


	$0 <parameter>

	Parameters
	----------
	dl72f								
	clean              - Deletes everything except bundles, resources and setup.sh
	cleandb            - Cleans the database if it already exists
	cleanmaster        - Doesn't download, just cleans up completely
	cluster		   - Sets up a clean 2 cluster node
	createdb           - Creates the database
	dl71               - Downloads the 7.1 CE GA3
	dlmaster           - Downloads the latest master
	rstaging           - Sets up remote staging where remote is 8080 and live is 9080


HELP_USAGE
}

#### Check if no parameters are sent

if [ $# -eq 0 ]
  then
    usage
fi

#### Accepts Parameters
for setupParameters in "$@"
do
    $setupParameters
done
