{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules;
in {
  options.modules.desktop = mkOption {
    type = types.enum ["hyprland"];
    default = "hyprland";
    description = ''
      Select the desktop environment to use.
    '';
  };

  imports = [
    ./hyprland
  ];
}
