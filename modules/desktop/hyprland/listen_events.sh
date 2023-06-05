
function handle {
  if [[ ${1} = *openwindow* || ${1} = *closewindow* || ${1} = *movewindow* || ${1} = *workspace* ]]; then
    ACTIVE_WORKSPACE=$(hyprctl monitors | grep -m1 "active workspace:" | grep -o "(.\+)" | grep -o "[^()]")

    NB_WINDOWS=$(hyprctl workspaces | grep -a1 "workspace ID .\+ (${ACTIVE_WORKSPACE})" | grep "windows: " | grep -o "[0-9]\+")

    if [[ ${NB_WINDOWS} = 1 ]]; then
        mode="fullscreen"
    else
        mode="tiled"
    fi
    
    rm /tmp/display_mode
    echo "{ \"mode\": \"${mode}\" }" >> /tmp/display_mode

  fi
}

socat - UNIX-CONNECT:/tmp/hypr/$(echo $HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock | while read line; do handle $line; done 


