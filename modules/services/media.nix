[
  {
    targets = [ "nixosConfiguration" ];
    conf = { config, pkgs, ... }: {

      age.secrets.jellyfinS3 = {
        file = ../../secrets/jellyfin_s3_secret.age;
        owner = config.services.jellyfin.user;
        group = config.services.jellyfin.group;
        mode = "400";
      };

      age.secrets.jellyfinCrypt = {
        file = ../../secrets/jellyfin_crypt.age;
        owner = config.services.jellyfin.user;
        group = config.services.jellyfin.group;
        mode = "400";
      };

      services = {
        nginx.virtualHosts."media.vagahbond.com" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:8096";
            proxyWebsockets = true; # needed if you need to use WebSocket
          };
        };
        jellyfin = {
          enable = true;
          dataDir = "/var/lib/jellyfin";

        };
      };

      systemd.services = {
        jellyfin = {
          requires = [ "jellyfin-rclone-s3-mount.service" ];
          after = [ "jellyfin-rclone-s3-mount.service" ];
        };

        jellyfin-rclone-s3-mount =
          let

            mountDir = "${config.services.jellyfin.dataDir}/media";
            bucketName = "vagahbond-jellyfin-s3";
          in
          {
            description = "rclone mount for S3 for jellyfin";
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
            wantedBy = [
              "multi-user.target"
            ];

            environment = {
              RCLONE_CONFIG_S3REMOTE_TYPE = "s3";
              RCLONE_CONFIG_S3REMOTE_PROVIDER = "AWS";
              RCLONE_CONFIG_S3REMOTE_REGION = "ap-southeast-2";
              RCLONE_CONFIG_MEDIA_TYPE = "crypt";
              RCLONE_CONFIG_MEDIA_REMOTE = "s3remote:${bucketName}";
              RCLONE_CONFIG_MEDIA_FILENAME_ENCRYPTION = "standard";
              RCLONE_CONFIG_MEDIA_DIRECTORY_NAME_ENCRYPTION = "true";
              RCLONE_CONFIG_MEDIA_STRICT_NAMES = "true";
            };
            script = ''
              export PATH="${config.security.wrapperDir}:$PATH"
              exec ${pkgs.rclone}/bin/rclone mount media: ${mountDir} \
                --config /dev/null \
                --read-only \
                --dir-cache-time 1h \
                --cache-dir /var/cache/jellyfin-rclone \
                --vfs-cache-mode full \
                --vfs-cache-max-size 5G \
                --vfs-read-ahead 128M \
                --buffer-size 64M \
                --umask 002
            '';

            serviceConfig = {
              CacheDirectory = "jellyfin-rclone";
              Type = "notify";
              EnvironmentFile = [
                config.age.secrets.jellyfinS3.path
                config.age.secrets.jellyfinCrypt.path
              ];
              User = config.services.jellyfin.user;
              ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${mountDir}";
              ExecStop = "${config.security.wrapperDir}/fusermount3 -u ${mountDir}";

              Restart = "always";
              RestartSec = 10;
            };
          };
      };
    };
  }
]
