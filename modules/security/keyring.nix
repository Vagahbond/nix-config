{
  targets = [
    "framework"
    "platypute"
  ];

  nixosConfiguration =
    { config, username, ... }:
    {
      environment.persistence.${config.impermanence.storageLocation} = {
        users.${username} = {
          directories = [
            ".local/share/keyring"
          ];
        };
      };
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      security.pam.services.gnupg = {
        enable = true;
        gnupg.enable = true;
      };

    };
}
