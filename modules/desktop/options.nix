{lib, ...}:
with lib; {
  options.modules.desktop = {
    session = mkOption {
      example = ["hyprland" "gamescope"];

      type = types.enum ["hyprland" "gamescope"];
      default = [];
      description = ''
        The session you want to use (DE or WM with everything around)
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
