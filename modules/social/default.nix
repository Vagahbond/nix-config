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

  catppuccin-mocha = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "discord";
    rev = "0f2c393b11dd8174002803835ef7640635100ca3";
    hash = "sha256-iUnLLAQVMXFLyoB3wgYqUTx5SafLkvtOXK6C8EHK/nI=";
  };
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
      environment.persistence.${impermanence.storageLocation} = {
        users.${username} = {
          # reeeeeeeeee
          directories = [
            #".config/discord"
            #".config/Vencord/settings"
            ".config/ArmCord"
          ];
        };
      };

      home-manager.users.${username} = {
        xdg.configFile."ArmCord/themes/mocha.theme.css" = {
          source = ./mocha.theme.css; #"${catppuccin-mocha}/themes/mocha.theme.css";
        };
      };

      # God damn you discord for breaking every two days
      environment.systemPackages = with pkgs; [
        armcord
        # discord broky yet AGAIN
        # (discord.override {
        #  withOpenASAR = true;
        #   withVencord = true;
        # })
        # webcord-vencord
      ];
    })
    (mkIf cfg.matrix.enable {
      environment.persistence.${impermanence.storageLocation} = {
        users.${username} = {
          directories = [
            #  ".config/discord"
            #  ".config/Vencord/settings"
          ];
          files = [
          ];
        };
      };

      environment.systemPackages = with pkgs; [
        element-desktop
      ];
    })
  ];
}
