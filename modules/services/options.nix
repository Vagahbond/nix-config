{lib, ...}:
with lib; {
  options.modules.services = {
    ssh = {
      enable = mkEnableOption "ssh";
    };

    nextcloud = {
      enable = mkEnableOption "nextcloud";
      port = mkOption {
        type = types.int;
        default = 8080;
      };
    };
  };
}
