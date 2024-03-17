{lib, ...}:
with lib; {
  options.modules.services = {
    ssh = {
      enable = mkEnableOption "ssh";
    };

    proxy = {
      enable = mkEnableOption "proxy";
    };

    nextcloud = {
      enable = mkEnableOption "nextcloud";
      #   backup = mkEnableOption "Backup your data daily";
    };

    vaultwarden = {
      enable = mkEnableOption "Vaultwarden";
    };

    postgres = {
      enable = mkEnableOption "postgres";
    };

    builder = {
      enable = mkEnableOption "builder";
    };

    homePage.enable = mkEnableOption "Home page";

    blog.enable = mkEnableOption "blog";
  };
}
