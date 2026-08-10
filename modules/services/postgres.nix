[
  {
    targets = [ "nixosConfiguration" ];
    conf =
      {
        pkgs,
        config,
        ...
      }:
      let
        backupUploadBucket = "vagahbond-postgres-backup";
        backupUploadRegion = "ap-southeast-2";
        backupUploadServiceName = "postgres-backup-s3-upload";
      in
      {
        age.secrets = {
          postgresBackupS3AccessKey = {
            file = ../../secrets/postgres_backup_s3_access_key.age;
            owner = "postgres";
            group = "postgres";
            mode = "400";
          };
          postgresBackupS3SecretKey = {
            file = ../../secrets/postgres_backup_s3_secret_key.age;
            owner = "postgres";
            group = "postgres";
            mode = "400";
          };
        };

        environment = {
          persistence.${config.persistence.storageLocation} = {
            directories = [
              {
                directory = "/var/backup/postgresql";
                user = "postgres";
                group = "postgres";
                mode = "u=rwx,g=rx,o=";
              }
              # {
              #   directory = "/var/lib/postgresql";
              #   user = "postgres";
              #   group = "postgres";
              #   mode = "u=rwx,g=rx,o=";
              # }
            ];
          };

          systemPackages = with pkgs; [ rainfrog ];

          # alias to access db TUI
          shellAliases = {
            db = "sudo -u postgres rainfrog --username postgres --host /run/postgresql --password \"\" --port 5432 --driver postgresql";

          };
        };
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
              log_destination = pkgs.lib.mkForce "syslog";
            };
          };
          postgresqlBackup = {
            enable = true;
            backupAll = true;
          };
        };

        # Once the daily postgresqlBackup dump succeeds, trigger an upload of
        # the backup directory to S3 so dumps are also available off-host.
        systemd.services = {
          postgresqlBackup = {
            unitConfig.OnSuccess = [ "${backupUploadServiceName}.service" ];
          };

          "${backupUploadServiceName}" = {
            description = "Upload PostgreSQL backups to S3";

            after = [ "postgresqlBackup.service" ];

            path = [ pkgs.rclone ];

            serviceConfig = {
              Type = "oneshot";
              User = "postgres";
              Group = "postgres";
            };

            script = ''
              set -euo pipefail

              export RCLONE_CONFIG_PGBACKUP_TYPE="s3"
              export RCLONE_CONFIG_PGBACKUP_PROVIDER="AWS"
              export RCLONE_CONFIG_PGBACKUP_REGION="${backupUploadRegion}"
              export RCLONE_CONFIG_PGBACKUP_ACCESS_KEY_ID="$(cat ${config.age.secrets.postgresBackupS3AccessKey.path})"
              export RCLONE_CONFIG_PGBACKUP_SECRET_ACCESS_KEY="$(cat ${config.age.secrets.postgresBackupS3SecretKey.path})"

              rclone sync \
                ${config.services.postgresqlBackup.location} \
                "pgbackup:${backupUploadBucket}" \
                --checksum
            '';
          };
        };
      };
  }
]
