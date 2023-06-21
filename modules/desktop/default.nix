{lib, ...}:
with lib; {
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
