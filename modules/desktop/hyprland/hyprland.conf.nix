{
  config,
  lib,
  ...
}: let
  inherit (config.modules.desktop) screenWidth screenHeight screenScalingRatio screenRefreshRate;
  isNvidiaEnabled = lib.lists.any (e: (e == config.modules.graphics.type)) ["nvidia-optimus" "nvidia"];
in ''
  debug:disable_logs = false


    # env = XDG_SESSION_TYPE,wayland
      # nvidia bullshit
  ${
    if isNvidiaEnabled # doesnt work with all those flags (I don't understand yo)
    then ''
      env = LIBVA_DRIVER_NAME,nvidia
      env = GBM_BACKEND,nvidia-drm
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = WLR_NO_HARDWARE_CURSORS,1
    ''
    else ""
  }
  # https://wiki.hyprland.org/Configuring/Multi-GPU/#telling-hyprland-which-gpu-to-use
  ${
    if config.modules.graphics.type == "nvidia-optimus"
    then ''
      #  env = WLR_DRM_DEVICES,${config.modules.graphics.nvidia-path}:${config.modules.graphics.intel-path}
    ''
    else ""
  }


    # Special
    $background=1e1e2e
    $foreground=cdd6f4
    $cursor=b4befe

    # Colors
    $color0=11111b
    $color1=f38ba8
    $color2=cba6f7
    $color3=f9e2af
    $color4=89b4fa
    $color5=f5c2e7
    $color6=a6e3a1
    $color7=bac2de
    $color8=9399b2

  #   exec=gsettings set org.gnome.desktop.interface font-name 'Terminess Nerd Font Regular 14'
    exec=export GTK_THEME='Catppuccin-Mocha-Mauve-Dark'
    exec-once=hyprctl setcursor "Catppuccin-Mocha-Dark-Cursors" 24


    bind = SUPER, T, exec, foot
    bind=SUPER, SPACE, togglespecialworkspace, scratchpad
    bind = SUPERSHIFT, Q, killactive
    bind = SUPERSHIFT, E, exec,  kill -9 -1
    bind=SUPER,E,exec,thunar
    bind=SUPER,F,togglefloating,
    bind=SUPERSHIFT,Escape,exec, gtklock -i

    bind=ALT,SPACE,exec,killall anyrun || anyrun

    bind=SUPER,1,workspace,1
    bind=SUPER,2,workspace,2
    bind=SUPER,3,workspace,3
    bind=SUPER,4,workspace,4
    bind=SUPER,5,workspace,5
    bind=SUPER,6,workspace,6
    bind=SUPER,7,workspace,7
    bind=SUPER,8,workspace,8
    bind=SUPER,9,workspace,9
    bind=SUPER,0,workspace,10

    bind=ALT,1,movetoworkspace,1
    bind=ALT,2,movetoworkspace,2
    bind=ALT,3,movetoworkspace,3
    bind=ALT,4,movetoworkspace,4
    bind=ALT,5,movetoworkspace,5
    bind=ALT,6,movetoworkspace,6
    bind=ALT,7,movetoworkspace,7
    bind=ALT,8,movetoworkspace,8
    bind=ALT,9,movetoworkspace,9
    bind=ALT,0,movetoworkspace,10


    bindr=SUPER,left,movefocus,l
    bindr=SUPER,right,movefocus,r
    bindr=SUPER,up,movefocus,u
    bindr=SUPER,down,movefocus,d
    bindr=SUPERSHIFT,left,movewindow,l
    bindr=SUPERSHIFT,right,movewindow,r
    bindr=SUPERSHIFT,up,movewindow,u
    bindr=SUPERSHIFT,down,movewindow,d
    bindr=SUPERCONTROL,left,workspace,-1
    bindr=SUPERCONTROL,right,workspace,+1
    bindr=SUPERCONTROL,up,focusmonitor,l
    bindr=SUPERCONTROL,down,focusmonitor,r
    bindr=SUPER,Tab,workspace,previous
    bindr=SUPERALT,left,resizeactive,-20 0
    bindr=SUPERALT,right,resizeactive,20 0
    bindr=SUPERALT,up,resizeactive,0 -20
    bindr=SUPERALT,down,resizeactive,0 20

    bindr=SUPER,h,movefocus,l
    bindr=SUPER,l,movefocus,r
    bindr=SUPER,k,movefocus,u
    bindr=SUPER,j,movefocus,d
    bindr=SUPERSHIFT,h,movewindow,l
    bindr=SUPERSHIFT,l,movewindow,r
    bindr=SUPERSHIFT,k,movewindow,u
    bindr=SUPERSHIFT,j,movewindow,d
    bindr=SUPERCONTROL,h,workspace,-1
    bindr=SUPERCONTROL,l,workspace,+1
    bindr=SUPERCONTROL,k,focusmonitor,l
    bindr=SUPERCONTROL,j,focusmonitor,r
    bindr=SUPERALT,h,splitratio,-0.1
    bindr=SUPERALT,l,splitratio,+0.1

    bind=SUPER,mouse_down,workspace,e+1
    bind=SUPER,mouse_up,workspace,eDP-1

    # Brightness
    bind=,XF86MonBrightnessUp,exec,/home/$USER/.config/hypr/brightness.sh A
    bind=,XF86MonBrightnessDown,exec,/home/$USER/.config/hypr/brightness.sh U

    # Volume
    bind=,XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bind=,XF86AudioLowerVolume,exec,/home/$USER/.config/hypr/volume.sh -
    bind=,XF86AudioRaiseVolume,exec,/home/$USER/.config/hypr/volume.sh +

    # Player
    bind=,XF86AudioPlay,exec,playerctl play-pause
    bind=,XF86AudioPause,exec,playerctl pause
    bind=,XF86AudioNext,exec,playerctl next
    bind=,XF86AudioPrev,exec,playerctl previous


    bindm=SUPER,mouse:272,movewindow
    bindm=SUPER,mouse:273,resizewindow

    # Screenshots

    # Screenshot a window
    bind = SUPER, PRINT, exec, hyprshot -m window -r | satty --filename - --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png
    # Screenshot a monitor
    bind = , PRINT, exec, hyprshot -m output -r | satty --filename - --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png
    # Screenshot a region
    bind = SHIFT, PRINT, exec, hyprshot -m region -r | satty --filename - --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png

    input {
    	kb_layout=us
          	kb_variant=mac
          	kb_options=ctrl:rctrl_ralt

          	follow_mouse=1
          	natural_scroll=0

    	sensitivity = 0.0

          	touchpad {
            	natural_scroll=1
            	middle_button_emulation=true
          	}
    }

    gestures {
    	workspace_swipe = true
      # workspace_swipe_numbered = true

    }

    binds {
    	workspace_back_and_forth = true
    	allow_workspace_cycles = true
    }

    misc {
    	disable_autoreload = true
    	layers_hog_keyboard_focus = true
        disable_hyprland_logo = true
    }

    general {
          max_fps=${toString screenRefreshRate}

          # col.inactive_border = rgb(1C4070) rgb(684056) rgb(00263C) rgb(938F64) 90deg
          col.inactive_border = rgb(1C4070) rgb(684056) 45deg
          # col.active_border = rgb(1C4070) rgb(684056) rgb(00263C) rgb(938F64) 90deg
          # col.active_border = rgb(89b4fa) rgb(cba6f7) 45deg
          col.active_border = rgb($color2)
          layout = dwindle
          resize_on_border = true
          extend_border_grab_area = 15
          gaps_in = 5
          gaps_out = 5
          border_size = 3

          bezier=overdone,0.68, -0.40, 0.200, 1.30
          bezier=overdone2,0.175, 0.885, 0.32, 1.275
          bezier=slowstart,0.6, 0.04, 0.98, 0.335
          bezier=slowend,0.19, 1, 0.22, 1

          animation=workspaces,1,3,slowend,slide
          animation=specialWorkspace,1,6,overdone,slidevert

          animation=windowsMove,1,4,overdone2,slide
          animation=windowsIn,1,4,overdone2,slide
          animation=windowsOut,1,4,overdone2,slide

          animation=fadeIn,1,2,slowend
          animation=fadeOut,1,2,slowstart
    }

    decoration {
    	fullscreen_opacity = 0.1
    	inactive_opacity = 0.6
    	active_opacity = 0.8
    	dim_inactive=true
      dim_strength=0.1
      rounding = 12
      blur {
    	  enabled = true
    	  size = 10
    	  passes = 3
        ignore_opacity = true
        special = false
      }
    	drop_shadow = true
      shadow_range = 8
      # shadow_render_power = 4
    	col.shadow = rgba($color2AA)
    	col.shadow_inactive = rgba($backgroundFF)
    }

    dwindle {
    	no_gaps_when_only = true
    }

    # Special rules
    windowrule=opaque,title:^(.*Firefox.*)$
    windowrule=opaque,title:^(.*Vlc.*)$
    windowrule=opaque,title:^(.*Visual Studio Code.*)$
    windowrule=opaque,title:^(.*Oracle VM VirtualBox.*)$

    windowrulev2 = opaque,fullscreen:1
    windowrulev2 = fullscreen, title:(.*)(satty)$

    windowrule = float, title:^(Firefox — Sharing Indicator)$
    windowrule = move 0 0, title:^(Firefox — Sharing Indicator)$
    windowrule = size 30 30, title:^(Firefox - Sharing Indicator)$



    # monitor=desc:Hewlett Packard HP E241i CN442414T9,highres, 1504x0, 1
    # monitor=desc:Microstep MAG342CQRV DB6H070C00454,highres, 1504x0, 1
    # monitor=eDP-1, 2256x1504@60, 0x0, 1.5
    # monitor=,highres,auto,1, mirror, eDP-1
    # monitor=,highres,1504x0, 1



    monitor=desc:Hewlett Packard HP E241i CN442414T9,highres, ${toString (screenWidth / screenScalingRatio)}x0, 1
    monitor=desc:Microstep MAG342CQRV DB6H070C00454,highres, 0x0, 1

    monitor=eDP-1, ${toString screenWidth}x${toString screenHeight}@${toString screenRefreshRate}, 3441x0, ${toString screenScalingRatio}
    ${
    if (screenScalingRatio != 1)
    then ''
      env = GDK_SCALE,${toString screenScalingRatio}
      env = XCURSOR_SIZE,${toString (16 * screenScalingRatio)}
    ''
    else ""
  }

    xwayland:force_zero_scaling = true

    # monitor=,highres,auto,1, mirror, eDP-1
    monitor=,highres,1504x0, 1

    workspace=1, monitor:eDP-1, default:true
    workspace=2, monitor:eDP-1, default:false
    workspace=3, monitor:eDP-1, default:false
    workspace=4, monitor:eDP-1, default:false
    workspace=5, monitor:eDP-1, default:false

    workspace = special:scratchpad, on-created-empty:foot zsh -c 'nitch; zsh -i' & gnome-pomodoro,gapsout:50

    exec = hyprpaper

    monitor=eDP-1,addreserved,0,0,60,0

    layerrule = ignorealpha 0.6,gtk-layer-shell
    layerrule = blur,gtk-layer-shell

    # exec-once = eww daemon
    # exec-once = eww open bar --no-daemonize
    # exec-once = eww open clock --no-daemonize
    exec = eww kill
    exec = zsh $HOME/.config/hypr/eww_widgets.sh
''
