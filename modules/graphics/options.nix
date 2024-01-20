{lib, ...}:
with lib; {
  options.modules.graphics = {
    type = mkOption {
      # if yours is missing, don't hesitate to PR
      type = types.enum [null "nvidia-optimus" "intel" "nvidia-passthrough"];
      description = "Enable GUI: all GUI related packages will be installed, as well as drivers if needed.";
      default = null;
      example = "intel";
    };

    nvidia-path = mkOption {
      type = types.str;
      description = "Path to nvidia card";
      default = "";
      example = "/dev/dri/card0";
    };

    intel-path = mkOption {
      type = types.str;
      description = "Path to intel card";
      default = "";
      example = "/dev/dri/card1";
    };

    gpuIds = {
      video = mkOption {
        type = types.str;
        description = "ID of nvidia video card";
        default = "";
        example = "10de:2482";
      };

      audio = mkOption {
        type = types.str;
        description = "ID of NoVideo audio card";
        default = "";
        example = "10de:228b";
      };
    };
  };
}
