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

    widgets = {
      eww.enable = mkEnableOption "Eww";
      ags.enable = mkEnableOption "AGS";
    };

    file-explorer = mkOption {
      example = "thunar";
      type = types.enum ["thunar"];
      default = "thunar";
      description = ''
        The file explorer you want to use.
      '';
    };

    notifications = mkOption {
      example = "dunst";
      type = types.enum ["mako"];
      default = "mako";
      description = ''
        The notifications daemon you want to use.
      '';
    };

    terminal = mkOption {
      example = "foot";
      type = types.enum ["foot"];
      default = "foot";
      description = ''
        The terminal emulator you want to use.
      '';
    };

    display-manager = mkOption {
      example = "sddm";
      type = types.enum ["sddm"];
      default = "sddm";
      description = ''
        The display manager you want to use.
      '';
    };

    launcher = mkOption {
      example = "wofi";
      type = types.enum ["anyrun"];
      default = "anyrun";
      description = ''
        The launcher you want to use.
      '';
    };

    lockscreen = mkOption {
      example = "hyprlock";
      type = types.enum ["hyprlock" null];
      default = "hyprlock";
      description = ''
        The lockscreen you want to use.
      '';
    };

    wallpaper = mkOption {
      example = "hyprpaper";
      type = types.enum ["hyprpaper" null];
      default = "hyprpaper";
      description = ''
        The wallpaper daemon you want to use.
      '';
    };
  };
}
