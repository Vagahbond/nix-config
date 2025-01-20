{lib, ...}:
with lib; {
  options.modules.desktop = {
    session = mkOption {
      example = "hyprland";
      type = types.enum ["hyprland" null];
      default = null;
      description = ''
        The session you want to use (null means no graphics environment.)
      '';
    };

    ags.enable = mkEnableOption "AGS";

    fileExplorer = mkOption {
      example = "thunar";
      type = types.enum ["thunar" null];
      default = null;
      description = ''
        The file explorer you want to use.
      '';
    };

    notifications = mkOption {
      example = "dunst";
      type = types.enum ["mako" null];
      default = null;
      description = ''
        The notifications daemon you want to use.
      '';
    };

    terminal = mkOption {
      example = "foot";
      type = types.enum ["foot" null];
      default = null;
      description = ''
        The terminal emulator you want to use.
      '';
    };

    displayManager = mkOption {
      example = "sddm";
      type = types.enum ["sddm" null];
      default = null;
      description = ''
        The display manager you want to use.
      '';
    };

    launcher = mkOption {
      example = "wofi";
      type = types.enum ["anyrun" null];
      default = null;
      description = ''
        The launcher you want to use.
      '';
    };

    lockscreen = mkOption {
      example = "hyprlock";
      type = types.enum ["hyprlock" null];
      default = null;
      description = ''
        The lockscreen you want to use.
      '';
    };

    wallpaper = mkOption {
      example = "hyprpaper";
      type = types.enum ["hyprpaper" null];
      default = null;
      description = ''
        The wallpaper daemon you want to use.
      '';
    };
  };
}
