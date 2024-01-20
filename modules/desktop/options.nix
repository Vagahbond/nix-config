{lib, ...}:
with lib; {
  options.modules.desktop = {
    sessions = mkOption {
      example = ["hyprland" "gamescope"];

      type = types.listOf (types.enum ["hyprland" "gamescope"]);
      default = [];
      description = ''
        List of sessions to enable (possible incompatibility between several ! )
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
