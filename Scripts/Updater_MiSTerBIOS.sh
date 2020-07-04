#!/bin/bash

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Copyright 2018-2020 Alessandro "Locutus73" Miele
# Copyright 2020 RetroDriven

# You can download the latest version of this script from:
# https://github.com/RetroDriven/MiSTerBIOS

: '
###### Disclaimer / Legal Information ######
By downloading and using this Script you are agreeing to the following:

* You are responsible for checking your local laws regarding the use of the ROMs that this Script downloads.
* You are authorized/licensed to own/use the BIOS associated with this Script.
* You will not distribute any of these files without the appropriate permissions.
* You own the original Consoles/BIOS.
* I take no responsibility for any data loss or anything, use the script at your own risk.
'

# Version 1.0 - 07/01/2020 - Added initial Script 

#=========   URL OPTIONS   =========

#Main URL
MAIN_URL="https://www.retrodriven.appboxes.co"

#BIOS URL
BIOS_URL="https://www.retrodriven.appboxes.co/MiSTerBIOS/BIOS/"

#Astrocade Main BIOS URL
ASTROCADE_MAIN_URL="https://www.retrodriven.appboxes.co/MiSTerBIOS/Games/Astrocade/"

#Gameboy Main BIOS URL
GAMEBOY_MAIN_URL="https://www.retrodriven.appboxes.co/MiSTerBIOS/Games/Gameboy/"

#MegaCD Main BIOS URL
MEGACD_MAIN_URL="https://www.retrodriven.appboxes.co/MiSTerBIOS/Games/MegaCD/"

#NES Main BIOS URL
NES_MAIN_URL="https://www.retrodriven.appboxes.co/MiSTerBIOS/Games/NES/"

#NeoGeo Unibios URL
NEOGEO_UNIBIOS_URL="http://unibios.free.fr/download/uni-bios-40.zip"

#TurboGrafx16 Main BIOS URL
TGFX16_MAIN_URL="https://www.retrodriven.appboxes.co/MiSTerBIOS/Games/TGFX16-CD/"

#=========   DIRECTORY OPTIONS   =========

#Base directory for all script’s tasks, "/media/fat" for SD root, "/media/usb0" for USB drive root.
BASE_PATH="/media/fat"

#Path where you'd like to download and save the entire BIOS Pack for manual use if the Default BIOS are not to your liking
BIOS_PATH="$BASE_PATH/BIOS"

#========= DO NOT CHANGE BELOW =========

TIMESTAMP=`date "+%m-%d-%Y @ %I:%M%P"`
ALLOW_INSECURE_SSL="true"
CURL_RETRY="--connect-timeout 15 --max-time 180 --retry 3 --retry-delay 5"

ORIGINAL_SCRIPT_PATH="$0"
if [ "$ORIGINAL_SCRIPT_PATH" == "bash" ]
then
	ORIGINAL_SCRIPT_PATH=$(ps | grep "^ *$PPID " | grep -o "[^ ]*$")
fi
INI_PATH=${ORIGINAL_SCRIPT_PATH%.*}.ini
if [ -f $INI_PATH ]
then
	eval "$(cat $INI_PATH | tr -d '\r')"
fi

if [ -d "${BASE_PATH}/${OLD_SCRIPTS_PATH}" ] && [ ! -d "${BASE_PATH}/${SCRIPTS_PATH}" ]
then
	mv "${BASE_PATH}/${OLD_SCRIPTS_PATH}" "${BASE_PATH}/${SCRIPTS_PATH}"
	echo "Moved"
	echo "${BASE_PATH}/${OLD_SCRIPTS_PATH}"
	echo "to"
	echo "${BASE_PATH}/${SCRIPTS_PATH}"
	echo "please relaunch the script."
	exit 3
fi

SSL_SECURITY_OPTION=""
curl $CURL_RETRY -q $MAIN_URL &>/dev/null
case $? in
	0)
		;;
	60)
		if [ "$ALLOW_INSECURE_SSL" == "true" ]
		then
			SSL_SECURITY_OPTION="--insecure"
		else
			echo "CA certificates need"
			echo "to be fixed for"
			echo "using SSL certificate"
			echo "verification."
			echo "Please fix them i.e."
			echo "using security_fixes.sh"
			exit 2
		fi
		;;
	*)
		echo "No Internet connection"
		exit 1
		;;
esac

#========= FUNCTIONS =========

#RetroDriven Updater Banner Function
RetroDriven_Banner(){
echo
echo " ------------------------------------------------------------"
echo "|           RetroDriven: MiSTer BIOS Updater v1.0            |"
echo " ------------------------------------------------------------"
sleep 1
}

#Download BIOS Function
Download_BIOS(){

    echo
    echo "================================================================"
    echo "                     Downloading BIOS Files                     "
    echo "================================================================"
    sleep 1

	#Create Directories
	mkdir -p "$BIOS_PATH"
    	cd "$BIOS_PATH"
    
	echo
	echo "Checking Existing BIOS Files for Updates/New Files......"
	echo

    	#Sync Files
    	lftp "$BIOS_URL" -e "mirror -p -P 25 --ignore-time --verbose=1 --log="$LOGS_PATH/BIOS_Downloads.txt"; quit"
	
	sleep 1
    	clear 	
}

#Download Default BIOS Function
Download_Default_BIOS(){

    echo
    echo "================================================================"
    echo "                     Downloading BIOS Files                     "
    echo "================================================================"
    sleep 1

	#Create Directories
	mkdir -p "$BIOS_PATH"
    	cd "$BIOS_PATH"
    
	echo
	echo "Checking Existing $BIOS_TYPE BIOS Files for Updates/New Files......"
	echo

    	#Sync Files
    	lftp "$BIOS_URL" -e "mirror -p -P 25 --ignore-time --verbose=1 --log="$LOGS_PATH/$BIOS_LOG"; quit"
	
	sleep 1
    	clear 	
}


#Download Default NeoGeo UniBios Function
Download_NEOGEO_UNIBIOS(){

    echo
    echo "================================================================"
    echo "                     Downloading BIOS Files                     "
    echo "================================================================"
    sleep 1

	#Create Directories
	mkdir -p "$BIOS_PATH"
    	cd "$BIOS_PATH"
    
	echo
	echo "Checking Existing $BIOS_TYPE BIOS Files for Updates/New Files......"
	echo

		curl ${CURL_RETRY} ${SSL_SECURITY_OPTION} -# --fail --location -o "uni-bios-40.zip" "$NEOGEO_UNIBIOS_URL" 
        unzip -o -j "uni-bios-40.zip"
        rm "uni-bios-40.zip"	

	sleep 1
    	clear 	
}

#Footer Function
Footer(){
clear
echo
echo "================================================================"
echo "                MiSTer BIOS Files are up to date!               "
echo "================================================================"
echo
}

#========= MAIN CODE =========

#RetroDriven Updater Banner
RetroDriven_Banner

#Create Logs Folder
LOGS_PATH="/media/fat/Scripts/.RetroDriven/Logs"
mkdir -p "$LOGS_PATH"

#SSL Handling for LFTP
if [ ! -f ~/.lftp/rc ]; then
    mount | grep "on / .*[(,]ro[,$]" -q && RO_ROOT="true"
    [ "$RO_ROOT" == "true" ] && mount / -o remount,rw
    
    mkdir -p ~/.lftp
    echo "set ssl:verify-certificate no" >> ~/.lftp/rc
    echo "set xfer:log no" >> ~/.lftp/rc

    [ "$RO_ROOT" == "true" ] && mount / -o remount,ro
fi

#Cleaner Download Details
	if ! grep -q "set xfer:log no" "/.lftp/rc"; then
	mount | grep "on / .*[(,]ro[,$]" -q && RO_ROOT="true"
    	[ "$RO_ROOT" == "true" ] && mount / -o remount,rw
	echo "set xfer:log no" >> /root/.lftp/rc
	[ "$RO_ROOT" == "true" ] && mount / -o remount,ro
	fi

	if ! grep -q "set ssl:verify-certificate no" "/.lftp/rc"; then 
	[ "$RO_ROOT" == "true" ] && mount / -o remount,rw
	echo "set ssl:verify-certificate no" >> /root/.lftp/rc
	[ "$RO_ROOT" == "true" ] && mount / -o remount,ro
	fi

#Download BIOS
Download_BIOS

#Download NeoGeo BIOS
BIOS_PATH="$BIOS_PATH/NeoGeo"
BIOS_TYPE="NeoGeo"
BIOS_URL="$NEOGEO_MAIN_URL"
BIOS_LOG="BIOS_NeoGeo_Downloads.txt"

if [ ! -f "$BIOS_PATH/uni-bios.rom" ];then
#Download_Default_BIOS $BIOS_PATH $BIOS_TYPE $BIOS_URL $BIOS_LOG
Download_NEOGEO_UNIBIOS $BIOS_PATH $BIOS_TYPE $BIOS_URL $BIOS_LOG
fi

if [ ! -f "$BASE_PATH/Games/NeoGeo/000-lo.lo" ] || [ ! -f "$BASE_PATH/Games/NeoGeo/sfix.sfix" ] || [ ! -f "$BASE_PATH/Games/NeoGeo/uni-bios.rom" ];then
mkdir -p "$BASE_PATH/Games/NeoGeo"
cd "$BIOS_PATH"
cp 000-lo.lo "$BASE_PATH/Games/NeoGeo"
cp sfix.sfix "$BASE_PATH/Games/NeoGeo"
cp uni-bios.rom "$BASE_PATH/Games/NeoGeo"
fi

#Download Default Astrocade BIOS
BIOS_PATH="$BASE_PATH/Games/Astrocade"
BIOS_TYPE="Astrocade"
BIOS_URL="$ASTROCADE_MAIN_URL"
BIOS_LOG="BIOS_Astrocade_Downloads.txt"

if [ ! -f "$BIOS_PATH/boot.rom" ];then
Download_Default_BIOS $BIOS_PATH $BIOS_TYPE $BIOS_URL $BIOS_LOG
fi

#Download Default Gameboy BIOS
BIOS_PATH="$BASE_PATH/Games/Gameboy"
BIOS_TYPE="Gameboy"
BIOS_URL="$GAMEBOY_MAIN_URL"
BIOS_LOG="BIOS_Gameboy_Downloads.txt"

if [ ! -f "$BIOS_PATH/boot1.rom" ];then
Download_Default_BIOS $BIOS_PATH $BIOS_TYPE $BIOS_URL $BIOS_LOG
fi

#Download Default MegaCD BIOS
BIOS_PATH="$BASE_PATH/Games/MegaCD"
BIOS_TYPE="MegaCD"
BIOS_URL="$MEGACD_MAIN_URL"
BIOS_LOG="BIOS_MegaCD_Downloads.txt"

if [ ! -f "$BIOS_PATH/boot.rom" ];then
Download_Default_BIOS $BIOS_PATH $BIOS_TYPE $BIOS_URL $BIOS_LOG
fi

#Download Default MegaCD BIOS
BIOS_PATH="$BASE_PATH/Games/MegaCD"
BIOS_TYPE="MegaCD"
BIOS_URL="$MEGACD_MAIN_URL"
BIOS_LOG="BIOS_MegaCD_Downloads.txt"

if [ ! -f "$BIOS_PATH/boot.rom" ];then
Download_Default_BIOS $BIOS_PATH $BIOS_TYPE $BIOS_URL $BIOS_LOG
fi

#Download Default NES BIOS
BIOS_PATH="$BASE_PATH/Games/NES"
BIOS_TYPE="NES"
BIOS_URL="$NES_MAIN_URL"
BIOS_LOG="BIOS_NES_Downloads.txt"

if [ ! -f "$BIOS_PATH/boot0.rom" ];then
Download_Default_BIOS $BIOS_PATH $BIOS_TYPE $BIOS_URL $BIOS_LOG
fi

#Download Default TGFX16-CD BIOS
BIOS_PATH="$BASE_PATH/Games/TGFX16-CD"
BIOS_TYPE="TGFX16-CD"
BIOS_URL="$TGFX16_MAIN_URL"
BIOS_LOG="BIOS_TGFX16CD_Downloads.txt"

if [ ! -f "$BIOS_PATH/cd_bios.rom" ];then
Download_Default_BIOS $BIOS_PATH $BIOS_TYPE $BIOS_URL $BIOS_LOG
fi

#Display Footer
Footer
echo "Downloaded Log Files are located here: $LOGS_PATH"
echo
