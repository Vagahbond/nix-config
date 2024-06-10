# TODO: inject PKGS
{
  colors,
  font,
  gtkTheme,
  mkHex,
  mkHexA,
  cursor,
  ...
}: ''
      debug:disable_logs = false

      # ENV
      env = GDK_SCALE,1.6
      env = GDK_BACKEND,wayland,x11
      env = QT_QPA_PLATFORM,wayland,xcb
      env = SDL_VIDEODRIVER,wayland

      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = XDG_SESSION_DESKTOP,Hyprland

      env = QT_AUTO_SCREEN_SCALE_FACTOR,1.6
      env = QT_QPA_PLATFORM,wayland;xcb
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      env = DISABLE_QT5_COMPAT,0

      env = MOZ_ENABLE_WAYLAND,1

      env = GTK_THEME,${gtkTheme.name}
      env = GTK_USE_PORTAL,1

      env = HYPRCURSOR_THEME,${cursor.name}
      env = HYPRCURSOR_SIZE,24

      #exec=gsettings set org.gnome.desktop.interface font-name '${font.name} 14'

      # BINDS

      bind = SUPER, T, exec, foot
      bind=SUPER, SPACE, togglespecialworkspace, scratchpad
      bind = SUPERSHIFT, Q, killactive
      bind = SUPERSHIFT, E, exec,  kill -9 -1
      bind=SUPER,E,exec,thunar
      bind=SUPER,F,togglefloating,
      bind=SUPER,F11,fullscreen,
      bind=SUPERSHIFT,Escape,exec, loginctl lock-session

      # launcher
      bind=ALT,SPACE,exec,killall anyrun || anyrun

      # Expo
      # bind = ALT, Tab, hyprexpo:expo, toggle # can be: toggle, off/disable or on/enable
      # bind = ALT, Tab, overview:toggle # can be: toggle, off/disable or on/enable

      # Brightness
      binde=,XF86MonBrightnessUp,exec,/home/$USER/.config/hypr/brightness.sh A
      binde=,XF86MonBrightnessDown,exec,/home/$USER/.config/hypr/brightness.sh U

      # Volume
      bindr=,XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      binde=,XF86AudioLowerVolume,exec,/home/$USER/.config/hypr/volume.sh -
      binde=,XF86AudioRaiseVolume,exec,/home/$USER/.config/hypr/volume.sh +

      # Player
      bindr=,XF86AudioPlay,exec,playerctl play-pause
      bindr=,XF86AudioPause,exec,playerctl pause
      bindr=,XF86AudioNext,exec,playerctl next
      bindr=,XF86AudioPrev,exec,playerctl previous


      bindm=SUPER,mouse:272,movewindow
      bindm=SUPER,mouse:273,resizewindow

      # Screenshots

      # Screenshot a window
      # bind = SUPER, PRINT, exec, hyprshot -m window -r | satty --filename - --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png
      bind = SUPER, PRINT, exec, grimblast --notify --cursor copysave active
      # Screenshot a monitor
      # bind = , PRINT, exec, hyprshot -m output -r | satty --filename - --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png
      bind = , PRINT, exec, grimblast --notify --cursor copysave output
      # Screenshot a region
      # bind = SHIFT, PRINT, exec, hyprshot -m region -r | satty --filename - --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png
      bind = SHIFT, PRINT, exec, grimblast --notify --cursor copysave area


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

      binde=SUPERALT,left,resizeactive,-20 0
      binde=SUPERALT,right,resizeactive,20 0
      binde=SUPERALT,up,resizeactive,0 -20
      binde=SUPERALT,down,resizeactive,0 20

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
      binde=SUPERALT,h,splitratio,-0.1
      binde=SUPERALT,l,splitratio,+0.1

      bind=SUPER,mouse_down,workspace,e+1
      bind=SUPER,mouse_up,workspace,e-1

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
        force_default_wallpaper = 0
        splash_font_family = ${font.name}
      }

      general {
        col.inactive_border = rgba(${mkHexA colors.base0C "CF"}) rgba(${mkHexA colors.base0B "CF"}) 45deg
        col.active_border = rgb(${mkHex colors.accent})

        layout = dwindle
        resize_on_border = true
        extend_border_grab_area = 10
        gaps_in = 5
        gaps_out = 10
        border_size = 1

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
        fullscreen_opacity = 0.9
        inactive_opacity = 0.8
        active_opacity = 1.0
        dim_inactive=false
        rounding = 6
        blur {
          enabled = true
          size = 10
          passes = 3
          ignore_opacity = true
        }
        drop_shadow = true
        shadow_range = 5
        shadow_render_power = 4
        shadow_offset =  5 5
        col.shadow = rgba(${mkHexA colors.base01 "aa"})
        col.shadow_inactive = rgba(${mkHexA colors.base01 "aa"})
      }

      dwindle {
        # no_gaps_when_only = true
        smart_split = true
      }

      # Special rules
      windowrule=opaque,title:^(.*Firefox.*)$
      windowrule=opaque,title:^(.*Visual Studio Code.*)$
      windowrule=opaque,title:^(.*Oracle VM VirtualBox.*)$
      windowrule=opaque,title:^(.*foot.*)$

      windowrulev2 = opaque,fullscreen:1
      windowrulev2 = float, title:(.*)(satty)$
      windowrulev2 = float, class:(.*)(thunar)$

      # firefox's sharing indicator
      windowrule = float, title:^(Firefox — Sharing Indicator)$
      windowrule = move 0 0, title:^(Firefox — Sharing Indicator)$
      windowrule = size 30 30, title:^(Firefox - Sharing Indicator)$

      windowrulev2 = immediate, class:^(steam_app)(.*)$
      windowrulev2 = immediate, title:^(glxgears)(.*)$
      windowrulev2 = opaque, class:^(steam_app)(.*)$
      windowrulev2 = opaque, class:^(libreoffice)(.*)$
      windowrulev2 = opaque, class:^(.*vlc.*)$
      windowrulev2 = opaque, class:^(.*mpv.*)$

      # Dofus keeps crashing
      windowrulev2 = fullscreen, class:^(dofus.exe)(.*)$

      # Issues with scaling in FL
      windowrulev2 = fullscreen, class:^(fl64.exe)(.*)$

      xwayland:force_zero_scaling = true


      workspace=1, monitor:eDP-1, default:true
      workspace=2, monitor:eDP-1, default:false
      workspace=3, monitor:eDP-1, default:false
      workspace=4, monitor:eDP-1, default:false
      workspace=5, monitor:eDP-1, default:false

      workspace = special:scratchpad, on-created-empty:foot zsh -c 'nitch; zsh -i' ,gapsout:50

      exec = hyprpaper
      exec-once=hypridle
      exec-once=ags --quit && ags

      # monitor=eDP-1,addreserved,0,0,60,0
      monitor=eDP-1,highres,auto,1.6
      monitor=,preferred,auto,1

      layerrule = ignorealpha 0,bar0
      layerrule = blur,bar0
      layerrule = ignorealpha 0,notifications
      layerrule = blur,notifications

      # exec = eww kill
      # exec = zsh $HOME/.config/hypr/eww_widgets.sh


  plugin {
      # hyprexpo {
      #       columns = 3
      #       gap_size = 5
      #       bg_col = rgb(${mkHex colors.background})
      #       workspace_method = center current # [center/first] [workspace] e.g. first 1 or center m+1

      #       enable_gesture = true # laptop touchpad, 4 fingers
      #       gesture_distance = 300 # how far is the "max"
      #       gesture_positive = false # positive = swipe down. Negative = swipe up.
      # }

      overview {
           workspaceActiveBackground = rgb(${mkHex colors.base01})
           workspaceInactiveBorder = rgb(${mkHex colors.base0C})
           workspaceActiveBorder = rgb(${mkHex colors.accent})
           panelColor = rgb(${mkHex colors.background})
           panelBorderColor = rgb(${mkHex colors.accent})

           exitOnClick =  1
           overrideGaps =  1
           dragAlpha = 1
           panelHeight =   180
           panelBorderWidth = 2
           onBottom = 0
           affectStrut = 1
           disableGestures =  0
           #showNewWorkspace = 0
           showEmptyWorkspace = 1
           drawActiveWorkspace = 0
           showSpecialWorkspace = 0
           workspaceBorderSize = 2
           reverseSwipe = 1
      }
  }

''
