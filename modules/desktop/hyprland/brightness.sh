#! /usr/bin/env zsh
file=/tmp/brightness_notif_id

if [ ! -e "$file" ] ; then
    touch "$file"
    echo "0" > $file
fi


light -${1} 5 && notify-send -u "critical" -t 100 -a "Brightness" -h string:syncronous:brightness -h int:value:$(light -G | cut -d'.' -f1) -r $(cat $file) -p "󰃟" > $file 

