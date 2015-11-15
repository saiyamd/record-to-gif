#!/bin/bash
# Author: Saiyam Doshi
# Install "byzanz" before using this script with,
# sudo apt-get update && sudo apt-get install byzanz

# Usage: $./recordtogif.sh <S> 
# provide 'S' to record full screen, otherwise drop it and this
# script will record current terminal only.
#
# You can also tweak this script as per your need.

#export PATH=$PATH:/usr/bin/

record_current_window() {
    echo "Record current window only!"
    XWININFO=$(xwininfo -id $(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}'))
}

record_full_screen() {
    echo "Whole screen will be recorded, click on any window!"
    XWININFO=$(xwininfo)
}

if [ ! -z "$1" ]; then
    if [[ "$1" == "S" || "$1" == "s" ]]; then
        record_full_screen
    else
        record_current_window
    fi
else
    record_current_window
fi

#screen recording duration 
read -p "Enter recording duration(seconds): " USERDUR
if [ -z $USERDUR ]; then
    USERDUR=5
    echo "Setting default duration $USERDUR sec."
fi

#window coodinates
X=`awk -F":  " '/Absolute upper-left X/{print $NF}' <<< "$XWININFO"`
Y=`awk -F":  " '/Absolute upper-left Y/{print $NF}' <<< "$XWININFO"`
W=`awk -F": " '/Width/{print $NF}' <<< "$XWININFO"`
H=`awk -F": " '/Height/{print $NF}' <<< "$XWININFO"`
#echo -e "X:$X\nY:$Y\nW:$W\nH:$H"

#timestamp for output filename
TIME=$(date +"%F_%H%M%S")

#delay before starting
DELAY=3

#gif image output directory
OUTDIR="$HOME/Pictures"

#output gif image name
OUTFILE="$OUTDIR/FILE_$USERDUR_$TIME.gif"

#inform user about recording time and delay
echo -e "Recording duration:$USERDUR sec.\nRecording will start in:$DELAY sec."

sleep $DELAY

#start recording
byzanz-record -c --verbose --delay=0 --duration=$USERDUR --x=$X --y=$Y --width=$W --height=$H $OUTFILE

echo "Output file: $OUTFILE"
