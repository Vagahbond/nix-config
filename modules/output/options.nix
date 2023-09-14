{lib, ...}:
with lib; {
  options.modules.output = {
    video = {
      enable = mkEnableOption "Video output";
    };

    audio = {
      enable = mkEnableOption "Audio output";
    };
    printer = {
      enable = mkEnableOption "Printer support";
    };
  };
}
