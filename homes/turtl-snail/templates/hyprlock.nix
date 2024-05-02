{
  colors,
  font,
  mkRGBA,
  mkRGB,
  mkHHex,
  radius,
  wallpaper,
  ...
}: ''

  general {
    grace = 0
    hide_cursor = true
  }

  # wallpaper
  background {
      monitor =
      path = ${wallpaper.package}/${wallpaper.name}   # supports png, jpg, webp (no animations, though)
      color = ${mkRGBA colors.background 1.0}

      blur_passes = 0 # 0 disables blurring
      blur_size = 7
      noise = 0.0117
      contrast = 0.8916
      brightness = 0.8172
      vibrancy = 0.1696
      vibrancy_darkness = 0.0
  }

  shape {
      monitor =
      size = 600, 400
      color = ${mkRGBA colors.background 0.5}
      rounding = ${builtins.toString radius}
      border_size = 0
      rotate = 0
      xray = false # if true, make a "hole" in the background (rectangle of specified size, no rotation)

      position = 75, 0
      halign = left
      valign = center

      shadow_passes = 3
  }


  # avatar picture
  image {
      monitor =
      path = /home/vagahbond/Pictures/avatar.jpeg
      size = 300 # lesser side if not 1:1 ratio
      rounding = -1 # negative values mean circle
      border_size = 2
      border_color =${mkRGB colors.accent}
      reload_time = -1 # seconds between reloading, 0 to reload with SIGUSR2

      position = 325, 0
      halign = center
      valign = center

      shadow_passes = 3
  }


  # input field, just in case
  input-field {
      monitor =
      size = 200, 25
      outline_thickness = 1
      dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
      dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
      dots_center = false
      dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
      outer_color = ${mkRGB colors.accent}
      inner_color = ${mkRGB colors.background}
      font_color = ${mkRGB colors.text}
      fade_on_empty = true
      fade_timeout = 1 # Milliseconds before fade_on_empty is triggered.
      placeholder_text = <i>Input Password...</i> # Text rendered in the input box when it's empty.
      hide_input = false
      rounding = ${builtins.toString radius} # -1 means complete rounding (circle/oval)
      check_color = -1# ${mkRGB colors.warning}
      fail_color = ${mkRGB colors.bad} # if authentication failed, changes outer_color and fail message color
      fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i> # can be set to empty
      fail_transition = 300 # transition time in ms between normal outer_color and fail_color
      capslock_color = ${mkRGB colors.warning}
      numlock_color = -1
      bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
      invert_numlock = false # change color if numlock is off
      swap_font_color = false # see below

      position = -200, -75
      halign = center
      valign = center


  }

  # Salutation message
  label {
      monitor =
      text =Hi there, <span foreground='#${mkHHex colors.accent}'>$USER</span>.
      text_align = left # center/right or any value for default left. multi-line text alignment inside label container
      color = ${mkRGB colors.text}
      font_size = 23
      font_family = ${font.name}
      rotate = 0 # degrees, counter-clockwise

      position = 100, 150
      halign = left
      valign = center

      shadow_passes = 3
  }

  # Date
  label {
      monitor =
      text =cmd[update:3600000] echo "It's <span foreground='#${mkHHex colors.accent}'>$(date +%A)</span>, <span foreground='#${mkHHex colors.accent}'>$(date +%B)</span> the <span foreground='#${mkHHex colors.accent}'>$(date +%d)</span> of <span foreground='#${mkHHex colors.accent}'>$(date +%Y)</span>."
      text_align = left # center/right or any value for default left. multi-line text alignment inside label container
      color = ${mkRGB colors.text}
      font_size = 23
      font_family = Noto Sans
      rotate = 0 # degrees, counter-clockwise

      position = 100, 50
      halign = left
      valign = center

      shadow_passes = 3

  }

  # time
  label {
      monitor =
      text =cmd[update:1000] echo "It's also <span foreground='#${mkHHex colors.accent}'>$(date +%H)</span>:<span foreground='#${mkHHex colors.accent}'>$(date +%M)</span>:<span foreground='#${mkHHex colors.accent}'>$(date +%S)</span>."
      text_align = left # center/right or any value for default left. multi-line text alignment inside label container
      color = ${mkRGB colors.text}
      font_size = 23
      font_family = ${font.name}
      rotate = 0 # degrees, counter-clockwise

      position = 100, -25
      halign = left
      valign = center

      shadow_passes = 3

  }

  # Funni note
  label {
      monitor =
      text = cmd[update:-1] hyprctl splash
      text_align = right # center/right or any value for default left. multi-line text alignment inside label container
      color = ${mkRGB colors.text}
      font_size = 12
      font_family = ${font.name}
      rotate = 0 # degrees, counter-clockwise

      position = -300, -162
      halign = center
      valign = center
  }

''
