{
  lib,
  config,
  pkgs,
  ...
} @ attrs:
with lib; let
  graphics = config.modules.graphics;

  cfg = config.modules;
in {
  options.modules.desktop = mkOption {
    type = types.enum ["hyprland"];
    default = "hyprland";
    description = ''
      Select the desktop environment to use.
    '';
  };

  config =
    {}
    // mkIf (cfg.desktop == "hyprland") (import ./hyprland {inherit pkgs;});
}
