#!/bin/bash
################################################################
# A very simple Bash script to download a YouTube video 
# and extract the music file from it. 
#
# Found at:
#    https://www.linuxjournal.com/content/grabbing-your-music-youtube-do-it-your-way
#
################################################################
# Update: Included some error handling.


#####
# Error and Usage messages
#####
#######
# Display and exit to script requirements.
#######
usage() {
	echo "Sorry but the system encountered a problem."
	echo ""
	echo $0" [arg]"
	echo ""
	echo "Provide URL as argument to video located on YouTube."
	exit 1;
}


###
# Check software message.
###
missingSoftware() {
	echo "Missing dependencies"
	echo ""
	echo "Missing one of three pieces of software required to run this script properly"
	echo "   The software items are; youtube-dl, ffmpeg, and lame"
	echo "   Please make sure that the software is installed on the system."
	echo ""
	exit 2;
}
####################


####
# Check if software is installed on system
youtube_dl=$(which youtube-dl) > /dev/null
ffmpeg=$(which ffmpeg) > /dev/null
lame=$(which lame) > /dev/null
if [ "${youtube-dl}" = "" ] || [ "${ffmpeg}" = "" ] || [ "${lame}" = "" ]; then
	missingSoftware;
fi
####


# Get the URL from the first arguement.
address=$1


# Variable Declaration
video_id=''
video_title=''
regex='v=(.*)'
currentVideoTitle=''
filename=''
getExt=''


# Adding the download to a history file
echo ${address} >> /home/hellspawn/YouTube/downloadFileList.txt1


if [[ ${address} =~ ${regex} ]]; then
	video_id=${BASH_REMATCH[1]}
	video_id=$(echo $video_id | cut -d'&' -f1)
	echo "VIDEO ID: "${video_id}
else
	usage;
fi


video_title="$(${youtube_dl} --get-title $address | tr ' ' '_')"
echo "VIDEO TITLE: "${video_title}


${youtube_dl} --audio-quality 0 $address # Download the file.


currentVideoTitle=$(echo ${video_title} | tr '_' ' ')
currentVideoTitle=$(ls -1 "${currentVideoTitle}-${video_id}"*)
echo "CURRENT VIDEO TITLE: "${currentVideoTitle}


filename=$(basename "${currentVideoTitle}")
echo $filename
getExt="${filename##*.}"


echo "CURRENT EXT: "${getExt}
echo "FULL NAME OF FILE IS: "${currentVideoTitle}


${ffmpeg} -i "${currentVideoTitle}" "${currentVideoTitle}".wav
${lame} -b 320 -v  "${currentVideoTitle}".wav "${video_title}-${video_id}".mp3
rm "${currentVideoTitle}".wav


exit 0;
