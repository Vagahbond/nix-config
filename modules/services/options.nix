{lib, ...}:
with lib; {
  options.modules.services = {
    ssh = {
      enable = mkEnableOption "ssh";
    };

    nextcloud = {
      enable = mkEnableOption "nextcloud";
      backup = mkEnableOption "Backup your data daily";
    };

    postgres = {
      enable = mkEnableOption "postgres";
    };
  };
}
