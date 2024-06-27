{
  lib,
  config,
  ...
}:
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
      backup = mkEnableOption "Backup your data";
    };

    vaultwarden = {
      enable = mkEnableOption "Vaultwarden";
    };

    postgres = {
      enable = mkOption {
        description = "Whether to enable postgres";
        default = config.modules.services.nextcloud.enable;
        type = types.bool;
      };
    };

    builder = {
      enable = mkEnableOption "builder";
    };

    homePage.enable = mkEnableOption "Home page";

    blog.enable = mkEnableOption "blog";

    universe.enable = mkEnableOption "Uni-verse";

    cockpit.enable = mkEnableOption "Cockpit";

    notes.enable = mkEnableOption "silverbullet";
  };
}
