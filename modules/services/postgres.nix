{
  pkgs,
  lib,
  storageLocation,
}: {
  environment.persistence.${storageLocation} = {
    directories = [
      {
        directory = "/var/lib/postgresql";
        user = "postgres";
        group = "postgres";
        mode = "u=rwx,g=rx,o=";
      }
    ];
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    dataDir = "/var/lib/postgresql";

    enableTCPIP = false;

    checkConfig = true;
    settings = {
      log_connections = true;
      log_statement = "all";
      logging_collector = true;
      log_disconnections = true;
      log_destination = lib.mkForce "syslog";
    };
    /*
      ensureUsers = [
      {
        name = "postgres";
        ensurePermissions."ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
      }
    ];
    */
  };
}
