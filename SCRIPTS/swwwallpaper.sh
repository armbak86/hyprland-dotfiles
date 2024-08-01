#!/usr/bin/env sh

lockFile="/tmp/hyde$(id -u)$(basename ${0}).lock"
[ -e "${lockFile}" ] && echo "An instance of the script is already running..." && exit 1
touch "${lockFile}"
trap 'rm -f ${lockFile}' EXIT

# // define functions

Set_Index()
{
    if [ "${1}" == "n" ] ; then
        if [ "$imgIndex" == "$imgCount" ] ; then
            imgIndex=0
        else
            imgIndex=$(($imgIndex + 1)) 
        fi
    elif [ "${1}" == "p" ] ; then
        if [ "$imgIndex" == "0" ] ; then
            imgIndex=$(($imgCount))
        else
            imgIndex=$(($imgIndex - 1))
        fi
    fi
}

Wall_Change()
{
    curWall
}

#// set variables

wallPath="$HOME/.config/wallpapers"
imgIndex=`cat ${wallPath}/swwwidx`
imgs=($wallPath/*)
imgCount=$(($(find "$wallPath" -type f | wc -l) - 1))
curWall=""

# #// evaluate options

while getopts "nps:" option ; do
    case $option in
    n ) # set next wallpaper
        xtrans="grow"
        Set_Index n
        ;;
    p ) # set previous wallpaper
        xtrans="outer"
        Set_Index p
        ;;
    * ) # invalid option
        echo "... invalid option ..."
        echo "n : set next wall"
        echo "p : set previous wall"
        exit 1 ;;
    esac
done

echo $imgIndex > ${wallPath}/swwwidx

# #// check swww daemon

swww query &> /dev/null
if [ $? -ne 0 ] ; then
    swww-daemon --format xrgb &
    swww query && swww restore
fi


# #// set defaults

[ -z "${xtrans}" ] && xtrans="grow"
[ -z "${wallFramerate}" ] && wallFramerate=60
[ -z "${wallTransDuration}" ] && wallTransDuration=0.7


# #// apply wallpaper

swww img "${imgs[$imgIndex]}" --transition-bezier .43,1.19,1,.4 --transition-type "${xtrans}" --transition-duration "${wallTransDuration}" --transition-fps "${wallFramerate}" --invert-y --transition-pos "$(hyprctl cursorpos | grep -E '^[0-9]' || echo "0,0")" &
