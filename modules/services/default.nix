{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  username = import ../../username.nix;
  hostname = config.networking.hostName;
  # inherit (config.modules.impermanence) storageLocation;
  cfg = config.modules.services;
in {
  imports = [./options.nix];

  config = mkMerge [
    (
      mkIf cfg.ssh.enable {
        age.secrets."${hostname}_access" = {
          file = ../../secrets/${hostname}_access.age;
          path = "${config.users.users.${username}.home}/.ssh/authorized_keys";
          mode = "600";
          owner = username;
          group = "users";
        };

        services.openssh = {
          enable = true;
          settings = {
            PasswordAuthentication = false;
          };
          banner = ''
             ██████╗████████╗███████╗ ██████╗
            ██╔════╝╚══██╔══╝██╔════╝██╔═══██╗
            ██║  ███╗  ██║   █████╗  ██║   ██║
            ██║   ██║  ██║   ██╔══╝  ██║   ██║
            ╚██████╔╝  ██║   ██║     ╚██████╔╝
             ╚═════╝   ╚═╝   ╚═╝      ╚═════╝


            This is a private system. Unauthorized access is prohibited.
            All actions will be logged.
            Seriously get the fuck out.
          '';
        };

        # Disable sudo on my servers. only su, you gotta know the root password.
        security.sudo.enable = true;
      }
    )
    (
      mkIf cfg.nextcloud.enable {
        age.secrets.nextcloudAdminPass = {
          file = ../../secrets/nextcloud_admin_pass.age;
          # path = "${config.users.users.${username}.home}/.ssh/authorized_keys";
          mode = "440";
          owner = "nextcloud";
          group = "users";
        };
        services.nextcloud = {
          enable = true;
          package = pkgs.nextcloud27;
          hostName = "cloud.vagahbond.com";
          home = "/nix/nextcloud";
          config = {
            adminpassFile = config.age.secrets.nextcloudAdminPass.path;
            # objectstore.s3.sseCKeyFile = "some file generated with openssl rand 32"
          };
          database = {
            createLocally = true;
          };
        };
      }
    )
  ];
}
