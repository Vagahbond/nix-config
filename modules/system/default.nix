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
        tree
      ];
    }
    (mkIf (cfg.processManager == "btop") {
      environment.systemPackages = with pkgs; [
        btop
      ];
    })
    (mkIf (cfg.processManager == "htop") {
      environment.systemPackages = with pkgs; [
        htop
      ];
    })
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
      ];
    })
  ];
}
