#! /usr/bin/env zsh

file=/tmp/volume_notif_id

if [ ! -e "$file" ] ; then
    touch "$file"
    echo "0" > $file
fi

wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.01$1 && notify-send -u "critical" -t 100 -a "Volume" -h string:syncronous:volume -h int:value:$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep  -oP "[0-9]\.[0-9]{2}" | read volume;echo ${$(($volume * 100))%.*}) -r $(cat $file) -p "󰕾" > $file
