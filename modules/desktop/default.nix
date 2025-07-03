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
    inputs.ags.nixosModules.default
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
        noto-fonts-cjk-sans
        noto-fonts-emoji
      ];
    }
    (
      lib.mkIf ("hyprland" == cfg.session) (import ./hyprland.nix {inherit config username storageLocation pkgs inputs;})
    )
    (lib.mkIf cfg.ags.enable {
      services.upower.enable = true;
      ags = {
        enable = true;
        vars = {
          bg = config.theme.colors.background;
          fg = config.theme.colors.text;
          inherit (config.theme.colors) good bad warning accent;
          inherit (config.theme) radius;
        };
      };
    })
    (lib.mkIf (cfg.fileExplorer == "yazi") {
      environment.systemPackages = with pkgs; [
      ];

      programs = {
        yazi = {
          enable = true;
          plugins = with pkgs.yaziPlugins; {
            inherit chmod mount git;
          };
          # flavour = {};
          #settings = {};
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
          settings = {
            font = "${font.name} 10}";
            anchor = "top-right";
            default-timeout = 4000;
            ignore-timeout = true;
            background-color = mkHHexA colors.background "DD";
            border-color = mkHHex colors.accent;
            text-color = mkHHex colors.base05;
            border-radius = radius;
            progress-color = "source ${mkHHex colors.accent}";
            # groupBy = "app-name";
            padding = "8";
          };
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
          # persistence.${impermanence.storageLocation} = {
          #   users.${username} = {
          #     directories = [
          # ".local/share/sddm"
          #     ];
          #   };
          # };

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
      };
    })
  ];
}
