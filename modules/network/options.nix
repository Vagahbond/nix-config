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
      enableClient = mkEnableOption "Enable ssh client";
      enableServer = mkEnableOption "Enable ssh server";
    };

    debug = {
      enable = mkEnableOption "Enable debugging";
    };
  };
}
