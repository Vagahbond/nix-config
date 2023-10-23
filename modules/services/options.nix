{lib, ...}:
with lib; {
  options.modules.services = {
    ssh = {
      enable = mkEnableOption "ssh";
    };

    nextcloud = {
      enable = mkEnableOption "nextcloud";
    };

    postgres = {
      enable = mkEnableOption "postgres";
    };
  };
}
