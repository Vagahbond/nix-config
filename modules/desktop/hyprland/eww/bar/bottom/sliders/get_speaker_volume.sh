ctl get-volume @DEFAULT_AUDIO_SINK@ | grep  -oP "[0-9]\.[0-9]{2}" | read volume; echo -n $volume * 100 | grep -oP "[0-9]{1,3}" | read value; echo "${value}.00"
