{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  graphics = config.modules.graphics;

  cfg = config.modules.productivity;
in {
  options.modules.productivity = {
    notion.enable = mkEnableOption "Enable Notion";
  };

  config =
    {}
    // mkIf cfg.notion.enable {
      environment.systemPackages = with pkgs; [
        notion-app-enhanced
      ];
    };
}
