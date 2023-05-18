#!/bin/sh

source $HOME/.cache/wal/colors.sh

bat=/sys/class/power_supply/BAT1/
per="$(cat "$bat/capacity")"
status="$(cat "$bat/status")"

if [ "$per" -gt "30" ]; then
	state="high"
elif [ "$per" -gt "20" ]; then
	state="low"
elif [ "$per" -gt "0" ]; then
	state="very-low"
else
    state="broken"
fi

if [ "$status" = "Charging" ]; then
	icon="󰚥"
else
	icon="󰠠"
fi


if [ -s /sys/class/power_supply/BAT1/capacity ]; then
    echo "{\"percent\": \"$per\", \"icon\": \"$icon\", \"charging\": \"$charging\", \"visible\": \"true\", \"state\": \"$state\"}"
else
    echo "{\"visible\": \"false\" }"
fi
