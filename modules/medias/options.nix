{lib, ...}:
with lib; {
  options.modules.medias = {
    video = {
      player = mkOption {
        type = types.bool;
        default = true;
        description = "Enable video player (VLC)";
        example = false;
      };

      editor = mkOption {
        type = types.bool;
        default = false;
        description = "Enable video editor (Shotcut)";
        example = false;
      };

      encoder = mkOption {
        type = types.bool;
        default = false;
        description = "Enable video encoder (Handbrake)";
        example = false;
      };

      downloader = mkOption {
        type = types.bool;
        default = false;
        description = "Enable video downloader (youtube-dl, nicotine+)";
        example = false;
      };

      recorder = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Kooha";
        example = true;
      };
    };

    audio = {
      player = mkOption {
        type = types.bool;
        default = false;
        description = "Enable audio player (Spicetify)";
        example = false;
      };

      editor = mkOption {
        type = types.bool;
        default = false;
        description = "Enable audio editor (Audacity)";
        example = false;
      };
    };

    image = {
      viewer = mkOption {
        type = types.bool;
        default = true;
        description = "Enable image viewer (Nomacs)";
        example = false;
      };

      editor = mkOption {
        type = types.bool;
        default = false;
        description = "Enable image editor (GIMP)";
        example = false;
      };
    };
  };
}
