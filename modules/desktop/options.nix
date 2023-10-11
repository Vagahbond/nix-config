{lib, ...}:
with lib; {
  options.modules.desktop = {
    rice = mkOption {
      type = types.enum ["hyprland" null];
      default = null;
      description = ''
        Select the desktop environment to use.
      '';
    };

    screenWidth = mkOption {
      type = types.int;
      default = 1920;
      description = ''
        Width for your screen
      '';
    };

    screenHeight = mkOption {
      type = types.int;
      default = 1080;
      description = ''
        Width for your screen
      '';
    };

    screenScalingRatio = mkOption {
      type = types.float;
      default = 1.0;
      description = ''
        Zoom ratio for your screen
      '';
    };

    screenRefreshRate = mkOption {
      type = types.int;
      default = 60;
      description = ''
        Refresh ratio for your screen
      '';
    };
  };
}
