[
  {
    targets = [ "darwinConfiguration" ];
    conf = _: {
      services.yabai = {
        enable = true;
        config = {
          focus_follows_mouse = "autoraise";
          mouse_follows_focus = "on";
          window_placement = "second_child";
          window_opacity = "off";
          top_padding = 10;
          bottom_padding = 10;
          left_padding = 10;
          right_padding = 10;
          window_gap = 10;

          layout = "bsp";
          skip_window_focus_animation = true;
          mouse_modifier = "cmd";
        };
      };

      services.skhd = {
        enable = true;
        skhdConfig = ''
          cmd - left : yabai -m window --focus west
          cmd - down : yabai -m window --focus south
          cmd - up : yabai -m window --focus north
          cmd - right : yabai -m window --focus east


          # swap/move focused window with neighbor

          # cmd + alt - left : yabai -m window --swap west
          # cmd + alt - down : yabai -m window --swap south
          # cmd + alt - up : yabai -m window --swap north
          # cmd + alt - right : yabai -m window --swap east

          # focus display (screen)
          cmd + shift - left : yabai -m display --focus west
          cmd + shift - down : yabai -m display --focus south
          cmd + shift - up : yabai -m display --focus north
          cmd + shift - right : yabai -m display --focus east

          # move focused window between spaces
          cmd + ctrl - left  : yabai -m window --space prev
          cmd + ctrl - right : yabai -m window --space next

          # toggle floating
          cmd + ctrl - f : yabai -m window --toggle float

          # toggle fullscreen
          ctrl - f : yabai -m window --toggle zoom-fullscreen

          # reload skhd
          cmd - escape : skhd --reload

          cmd + alt + ctrl - left : yabai -m window --resize left:-50:0
          cmd + alt + ctrl - down : yabai -m window --resize bottom:0:50
          cmd + alt + ctrl - up : yabai -m window --resize top:0:-50
          cmd + alt + ctrl - right : yabai -m window --resize right:50:0

        '';
      };
    };
  }
]
