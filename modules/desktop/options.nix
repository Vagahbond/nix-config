{lib, ...}:
with lib; {
  options.modules.desktop = {
    rice = mkOption {
      type = types.enum ["hyprland"];
      default = "hyprland";
      description = ''
        Select the desktop environment to use.
      '';
    };

    screenWidth = mkOption {
      type = types.Number;
      default = 1920;
      description = ''
        Width for your screen
      '';
    };

    screenHeight = mkOption {
      type = types.Number;
      default = 1080;
      description = ''
        Width for your screen
      '';
    };

    screenScalingRatio = mkOption {
      type = types.Number;
      default = 1;
      description = ''
        Zoom ratio for your screen
      '';
    };

    screenRefreshRate = mkOption {
      type = types.Number;
      default = 60;
      description = ''
        Refresh ratio for your screen
      '';
    };
  };
}
