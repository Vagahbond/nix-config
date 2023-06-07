#! /usr/bin/env zsh

light -${1} 5 && notify-send -u "critical" -t 100 -a "Brightness" -h string:syncronous:brightness -h int:value:$(light -G | cut -d'.' -f1) -r $(cat /tmp/brightness_notif_id) -p "󰃟" > /tmp/brightness_notif_id

