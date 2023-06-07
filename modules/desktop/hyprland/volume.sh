#! /usr/bin/env zsh

wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.01$1 && notify-send -u "critical" -t 100 -a "Volume" -h string:syncronous:volume -h int:value:$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep  -oP "[0-9]\.[0-9]{2}" | read volume;echo ${$(($volume * 100))%.*}) -r $(cat /tmp/volume_notif_id) -p "󰕾" > /tmp/volume_notif_id
