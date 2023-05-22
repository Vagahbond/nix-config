{
  pkgs,
  super,
  lib,
  config,
  ...
}:
with lib; let
  username = import ../../username.nix;

  graphics = config.modules.graphics;

  cfg = config.modules.social;

  catppuccin-mocha = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "discord";
    rev = "0f2c393b11dd8174002803835ef7640635100ca3";
    hash = "sha256-iUnLLAQVMXFLyoB3wgYqUTx5SafLkvtOXK6C8EHK/nI=";
  };
in {
  options.modules.social = {
    whatsapp.enable = mkEnableOption "Enable whatsapp";
    teams.enable = mkEnableOption "Enable teams";
    discord.enable = mkEnableOption "Enable discord";
  };

  config =
    {}
    // mkIf cfg.whatsapp.enable {
      environment.systemPackages = with pkgs; [
        whatsapp-for-linux
      ];
    }
    // mkIf cfg.teams.enable {
      environment.systemPackages = with pkgs; [
        teams
      ];
    }
    // mkIf cfg.discord.enable {
      home-manager.users.${username} = {
        xdg.configFile."WebCord/Themes/mocha" = {
          source = "${catppuccin-mocha}/themes/mocha.theme.css";
        };
      };
      environment.systemPackages = with pkgs; [
        webcord-vencord
      ];
    };
}
