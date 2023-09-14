{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  inherit (config.modules) graphics;

  cfg = config.modules.productivity;
in {
  imports = [./options.nix];

  config = mkMerge [
    (mkIf (cfg.notion.enable
      && (graphics.type != null)) {
      environment.systemPackages = with pkgs; [
        notion-app-enhanced
      ];
    })
    (mkIf (cfg.notion.enable
      && (graphics.type != null)) {
      environment.systemPackages = with pkgs; [
        appflowy
      ];
    })
  ];
}
