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
      services.upower.enable = true;

      home-manager.users.${username} = {
        imports = [inputs.ags.homeManagerModules.default];

        programs.ags = {
          enable = true;

          # null or path, leave as null if you don't want hm to manage the config
          configDir = ./ags;

          # additional packages to add to gjs's runtime
          extraPackages = with pkgs; [
            gtksourceview
            webkitgtk
            accountsservice
          ];
        };
      };
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
      lib.mkIf (cfg.launcher == "anyrun") (import ./anyrun.nix {
        inherit config username storageLocation pkgs inputs;
      })
    )
    (
      lib.mkIf (cfg.lockscreen == "hyprlock") (import ./hyprlock.nix {inherit config username templates;})
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
