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

      blur_passes = 1 # 0 disables blurring
      blur_size = 7
      noise = 0.0117
      contrast = 0.8916
      brightness = 0.8172
      vibrancy = 0.1696
      vibrancy_darkness = 0.0
  }

  # avatar picture
  image {
      monitor =
      path = /home/vagahbond/Pictures/avatar.png
      size = 600 # lesser side if not 1:1 ratio
      rounding = -1 # negative values mean circle
      border_size = 0
      border_color =${mkRGB colors.accent}
      reload_time = -1 # seconds between reloading, 0 to reload with SIGUSR2

      position = 650, 0
      halign = center
      valign = center

      shadow_passes = 3
  }


  # input field, just in case
  input-field {
      monitor =
      size = 400, 50
      outline_thickness = 1
      dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
      dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
      dots_center = false
      dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
      outer_color = ${mkRGB colors.accent}
      inner_color = ${mkRGB colors.background}
      font_color = ${mkRGB colors.text}
      fade_on_empty = true
      fade_timeout = 1000 # Milliseconds before fade_on_empty is triggered.
      placeholder_text = <i>Input Password...</i> # Text rendered in the input box when it's empty.
      hide_input = false
      rounding = ${builtins.toString radius} # -1 means complete rounding (circle/oval)
      check_color = ${mkRGB colors.warning}
      fail_color = ${mkRGB colors.bad} # if authentication failed, changes outer_color and fail message color
      fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i> # can be set to empty
      fail_transition = 300 # transition time in ms between normal outer_color and fail_color
      capslock_color = ${mkRGB colors.warning}
      numlock_color = -1
      bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
      invert_numlock = false # change color if numlock is off
      swap_font_color = false # see below

      position = 100, -706
      halign = left
      valign = top

      shadow_passes = 3

  }

  # Salutation message
  label {
      monitor =
      text =Hi there, <span foreground='#${mkHHex colors.accent}'>$USER</span>.
      text_align = left # center/right or any value for default left. multi-line text alignment inside label container
      color = ${mkRGB colors.text}
      font_size = 64
      font_family = ${font.name}
      rotate = 0 # degrees, counter-clockwise

      position = 100, -100
      halign = left
      valign = top

  }

  # Date
  label {
      monitor =
      text =cmd[update:3600000] echo "It's <span foreground='#${mkHHex colors.accent}'>$(date +%A)</span><br/><span foreground='#${mkHHex colors.accent}'>$(date +%B)</span> the <span foreground='#${mkHHex colors.accent}'>$(date +%d)</span> of <span foreground='#${mkHHex colors.accent}'>$(date +%Y)</span>."
      text_align = left # center/right or any value for default left. multi-line text alignment inside label container
      color = ${mkRGB colors.text}
      font_size = 46
      font_family = ${font.name}
      rotate = 0 # degrees, counter-clockwise

      position = 100, -346
      halign = left
      valign = top
  }

  # time
  label {
      monitor =
      text =cmd[update:1000] echo "It's also <span foreground='#${mkHHex colors.accent}'>$(date +%H)</span>:<span foreground='#${mkHHex colors.accent}'>$(date +%M)</span>:<span foreground='#${mkHHex colors.accent}'>$(date +%S)</span>."
      text_align = left # center/right or any value for default left. multi-line text alignment inside label container
      color = ${mkRGB colors.text}
      font_size = 46
      font_family = ${font.name}
      rotate = 0 # degrees, counter-clockwise

      position = 100, -558
      halign = left
      valign = top


  }

  # Funni note
  label {
      monitor =
      text = cmd[update:0] hyprctl splash
      text_align = right # center/right or any value for default left. multi-line text alignment inside label container
      color = ${mkRGB colors.text}
      font_size = 25
      font_family = ${font.name}
      rotate = 0 # degrees, counter-clockwise

      position = 100, 10
      halign = left
      valign = bottom
  }

''
