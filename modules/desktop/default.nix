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
  inherit (inputs.nix-cooker.lib) mkHHex;
  inherit (config.theme) displayManagerTheme colors radius templates;
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
      programs = {
        thunar = {
          enable = true;
          plugins = with pkgs.xfce; [
            thunar-archive-plugin
            thunar-media-tags-plugin
          ];
        };
      };
    })
    (lib.mkIf (cfg.notifications == "mako") {
      home-manager.users.${username} = {
        services.mako = {
          enable = true;
          anchor = "top-right";
          defaultTimeout = 4000;
          ignoreTimeout = true;
          backgroundColor = mkHHex colors.background;
          borderColor = mkHHex colors.accent;
          textColor = mkHHex colors.text;
          borderRadius = radius;
          progressColor = mkHHex colors.accent;
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
      lib.mkIf (cfg.displayManager == "sddm") {
        environment = {
          persistence.${storageLocation} = {
            directories = [
              "/var/lib/sddm"
            ];

            systemPackages = [
              displayManagerTheme.package
            ];

            services = {
              displayManager.sddm = {
                enable = true;
                theme = displayManagerTheme.name;
                autoNumlock = true;
                wayland.enable = true;
              };
            };
          };
        };
      }
    )

    (lib.mkIf (cfg.terminal == "wallpaper") {
      environment.systemPackages = with pkgs; [
        hyprpaper
      ];

      home-manager.users.${username} = {
        home.file.".config/hypr/hyprpaper.com".text = templates.hyprpaper;
        home.file.".config/hypr/wallpaper.jpg".text = templates.foot;
      };
    })
  ];
}
