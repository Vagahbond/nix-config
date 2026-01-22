
{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  inherit (config.modules) impermanence;
  cfg = config.modules.system;
  username = import ../../username.nix;
in {
  imports = [./options.nix];
  config = mkMerge [
    {
      environment.systemPackages = with pkgs; [
        fzf
        tealdeer
        bat
        dust
        powertop
        tree
        killall
        htop
        jq
        nitch
        socat
        systemctl-tui
      ];

      programs.appimage = {
        enable = true;
        binfmt = true;
      };
    }
    (mkIf cfg.ntfs.enable {
      environment.systemPackages = with pkgs; [
        ntfs3g
      ];
    })
    (mkIf cfg.rclone.enable {
      environment.persistence.${impermanence.storageLocation} = {
        users.${username} = {
          directories = [
            ".config/rclone"
          ];
        };
      };

      environment.systemPackages = with pkgs; [
        rclone
      ];
    })

    (mkIf cfg.compression.enable {
      environment.systemPackages = with pkgs; [
        zip
        unzip
        rar
        lz4
      ];
    })
  ];
}
