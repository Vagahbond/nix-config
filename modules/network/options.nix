{lib, ...}:
with lib; {
  options.modules.network = {
    wifi = {
      enable = mkEnableOption "wifi";
    };

    bluetooth = {
      enable = mkEnableOption "bluetooth";
    };

    ssh = {
      enable = mkEnableOption "ssh client";
    };

    debug = {
      enable = mkEnableOption "debugging";
    };
  };
}
