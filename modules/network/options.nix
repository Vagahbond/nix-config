{lib, ...}:
with lib; {
  options.modules.network = {
    wifi = {
      enable = mkEnableOption "Enable wifi";
    };

    bluetooth = {
      enable = mkEnableOption "Enable bluetooth";
    };

    ssh = {
      enable = mkEnableOption "Enable ssh client";
    };

    debug = {
      enable = mkEnableOption "Enable debugging";
    };
  };
}
