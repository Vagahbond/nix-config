{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  username = import ../../username.nix;

  cfg = config.modules.social;

  inherit (config.modules) impermanence;

  inherit (config.theme) templates colors font;

  inherit
    (inputs.nix-cooker.lib {
      inherit lib;
      inherit (config) theme;
    })
    mkHex
    ;
in {
  imports = [./options.nix];
  config = mkMerge [
    (mkIf cfg.whatsapp.enable {
      environment.systemPackages = with pkgs; [
        whatsapp-for-linux
      ];
    })

    (mkIf cfg.teams.enable {
      environment.systemPackages = with pkgs; [
        teams
      ];
    })

    (mkIf cfg.discord.enable {
      environment = {
        persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".config/vesktop"
              # ".config/ArmCord"
            ];
          };
        };

        systemPackages = [
          (pkgs.vesktop.overrideAttrs {
            desktopItems = [
              (pkgs.makeDesktopItem {
                name = "discord";
                desktopName = "Discord";
                exec = "vesktop --enable-features=UseOzonePlatform --ozone-platform=wayland";
                icon = "discord";
                startupWMClass = "Discord";
                genericName = "Internet Messenger";
                keywords = ["discord" "vencord" "electron" "chat"];
                categories = ["Network" "InstantMessaging" "Chat"];
              })
            ];
          })
        ];
      };

      home-manager.users.${username} = {
        home.file.".config/vesktop/themes/my.theme.css" = {
          text = templates.discord;
        };
      };
    })
    (mkIf cfg.matrix.enable {
      environment.systemPackages = with pkgs; [
        element-desktop
      ];
    })
  ];
}
