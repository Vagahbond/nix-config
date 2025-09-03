{
  pkgs,
  lib,
  storageLocation,
  config,
}: {
  environment.persistence.${storageLocation} = {
    directories = [
      {
        directory = "/var/backup/postgresql";
        user = "postgres";
        group = "postgres";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/var/lib/postgresql";
        user = "postgres";
        group = "postgres";
        mode = "u=rwx,g=rx,o=";
      }
    ];
  };

  # environment.systemPackages = with pkgs; [postgresql_17];

  services = {
    postgresql = {
      enable = true;

      package = pkgs.postgresql_17;
      dataDir = "/var/lib/postgresql/${config.services.postgresql.package.psqlSchema}";

      enableTCPIP = false;

      checkConfig = true;
      settings = {
        log_connections = true;
        log_statement = "all";
        logging_collector = true;
        log_disconnections = true;
        log_destination = lib.mkForce "syslog";
      };
    };
    postgresqlBackup = {
      enable = true;
      backupAll = true;
      pgdumpOptions = "";
    };
  };
}
