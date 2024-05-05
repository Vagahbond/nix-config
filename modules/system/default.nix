{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.system;
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
    }
    (mkIf cfg.ntfs.enable {
      environment.systemPackages = with pkgs; [
        ntfs3g
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
