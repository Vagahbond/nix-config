{
  lib,
  config,
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
          group = username;
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
        security.sudo.enable = false;
      }
    )
  ];
}
