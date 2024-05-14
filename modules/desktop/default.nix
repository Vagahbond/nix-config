{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.modules.desktop;
  username = import ../../username.nix;

  inherit (config.modules.impermanence) storageLocation;
  inherit (config.theme) font displayManagerTheme colors radius templates;

  inherit
    (inputs.nix-cooker.lib {
      inherit lib;
      inherit (config) theme;
    })
    mkHHex
    mkHHexA
    ;
in {
  imports = [
    ./options.nix
  ];

  config = lib.mkMerge [
    # Default packages for any env
    {
      environment.systemPackages = with pkgs; [
        # For laptop with light sensor
        iio-sensor-proxy
        # For notifications
        libnotify
      ];
      # Gotta have default fonts
      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
      ];
    }
    (
      lib.mkIf ("hyprland" == cfg.session) (import ./hyprland.nix {inherit config username storageLocation pkgs inputs;})
    )
    (lib.mkIf cfg.widgets.eww.enable {
      environment.systemPackages = with pkgs; [
        eww
      ];

      home-manager.users.${username} = {
        home.file.".config/eww".source = inputs.eww-config;
      };
    })
    (lib.mkIf cfg.widgets.ags.enable {
      # TODO: Install AGS lol
    })
    (lib.mkIf (cfg.fileExplorer == "thunar") {
      environment.systemPackages = with pkgs; [
        libgsf # odf files
        ffmpegthumbnailer
      ];

      # services.gvfs.enable = true; # Mount, trash, and other functionalities
      services.tumbler.enable = true; # Thumbnail support for images

      programs = {
        thunar = {
          enable = true;
          plugins = with pkgs.xfce; [
            thunar-archive-plugin
            thunar-media-tags-plugin
            thunar-volman
            thunar-media-tags-plugin
          ];
        };
      };
    })
    (lib.mkIf (cfg.notifications == "mako") {
      home-manager.users.${username} = {
        services.mako = {
          enable = true;
          font = "${font.name} 10}";
          anchor = "top-right";
          defaultTimeout = 4000;
          ignoreTimeout = true;
          backgroundColor = mkHHexA colors.background "DD";
          borderColor = mkHHex colors.accent;
          textColor = mkHHex colors.base05;
          borderRadius = radius;
          progressColor = "source ${mkHHex colors.accent}";
          # groupBy = "app-name";
          padding = "8";

          # TODO: Script to enable do-not-disturb I guess
          extraConfig = ''
            outer-margin=10

            [mode=do-not-disturb]
            invisible=1

          '';
        };
      };
    })
    (lib.mkIf (cfg.terminal == "foot") {
      environment.systemPackages = with pkgs; [
        foot
      ];

      home-manager.users.${username} = {
        home.file.".config/foot/foot.ini".text = templates.foot;
      };
    })

    (
      lib.mkIf (cfg.launcher == "anyrun") (import ./anyrun.nix {inherit config username storageLocation pkgs inputs;})
    )
    (
      lib.mkIf (cfg.lockscreen == "hyprlock") {
        home-manager.users.${username} = {
          programs.hyprlock = {
            enable = true;
            extraConfig = templates.hyprlock;
          };

          services.hypridle = {
            enable = true;
            settings = {
              general = {
                before_sleep_cmd = "loginctl lock-session";
                lock_cmd = "pidof hyprlock || hyprlock -q";
                unlock_cmd = "loginctl unlock-session";
                after_sleep_cmd = "hyprctl dispatch dpms on && notify-send \"Back from idle.\" \"Welcome back!\"";
              };
              listeners = [
                {
                  timeout = 150; # 2.5min.
                  on-timeout = "light -S set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
                  on-resume = "light -I"; # monitor backlight restore.
                }
                {
                  timeout = 300;
                  on-timeout = "playerctl pause";
                  on-resume = "playerctl play";
                }
                {
                  timeout = 270;
                  on-timeout = "notify-send \"Idle\" \"You're idle... locking in 30s.\"";
                }
                {
                  timeout = 300; # 5min
                  on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
                }

                {
                  timeout = 330; # 5.5min
                  on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
                  on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
                }

                {
                  timeout = 1800; # 30min
                  on-timeout = "systemctl suspend"; # suspend pc
                }
              ];
            };
          };
        };
      }
    )
    (
      lib.mkIf (cfg.displayManager == "sddm") {
        environment = {
          systemPackages = [
            displayManagerTheme.package
          ];
        };

        services = {
          displayManager.sddm = {
            enable = true;
            theme = displayManagerTheme.name;
            autoNumlock = true;
            wayland.enable = true;
          };
        };
      }
    )

    (lib.mkIf (cfg.wallpaper == "hyprpaper") {
      environment.systemPackages = with pkgs; [
        hyprpaper
      ];

      home-manager.users.${username} = {
        home.file.".config/hypr/hyprpaper.conf".text = templates.hyprpaper;
        home.file.".config/hypr/wallpaper.jpg".text = templates.foot;
      };
    })
  ];
}
