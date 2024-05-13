{lib, ...}: let
  mkWebServiceOption = name: description: (lib.mkOption {
    inherit description;
    default = {
      enable = false;
    };
    type = lib.types.submodule {
      options = {
        enable = lib.mkEnableOption name;

        internalAddr = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Internal address used to contact this service's container";
          example = "192.168.1.1";
        };

        externalAddr = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Address used to contact this service from outside (Most probably FQDN)";
          example = "my.superwebsite.com";
        };

        proxied = lib.mkEnableOption "proxy with TLS";
      };
    };
  });
in
  with lib; {
    options.modules.services = {
      ssh = {
        enable = mkEnableOption "ssh";
      };

      proxy = {
        enable = mkEnableOption "proxy";
      };

      nextcloud = mkWebServiceOption "Cloud" "Nextcloud service";

      blog = mkWebServiceOption "Blog" "writefreely blog service";

      vaultwarden = mkWebServiceOption "Vaultwarden" "Password manager service";

      homePage = mkWebServiceOption "Homepage" "My personnal website";

      postgres = {
        enable = mkEnableOption "postgres";
      };

      builder = {
        enable = mkEnableOption "builder";
      };
    };
  }
