{
  targets = [
    "platypute"
    "framework"
    "air"
  ];

  sharedConfiguration =
    {
      username,
      ...
    }:
    {
      users = {
        users = {
          ${username} = {
            description = "Main user";
          };
        };
      };
    };

  darwinConfiguration =
    { username, ... }:
    {
      users.users.${username}.home = "/Users/${username}";
    };

  nixosConfiguration =
    { config, username, ... }:
    {
      users = {
        mutableUsers = false;
        users = {
          ${username} = {
            isNormalUser = true;
            extraGroups = [ "wheel" ];
            hashedPassword = "$y$j9T$wNFGGvQeqSgVUXxTmOHX8.$wd5iVM5t01vuyNKR.bEcwBZIQ.t8qIxhPylDzhRYDC0""$y$j9T$ofYLQRbiSsTERtHKAoi.J1$XW1xU541EsKvdMc3WNMEliNvUn4tVxKl99PbSB5gUg/";
            home = "/home/${username}";

          };
          root = {
          };

        };
      };

      environment.persistence.${config.persistence.storageLocation} = {
        users.${username} = {
          directories = [
            "Projects"
            "Downloads"
            "Music"
            "Pictures"
            "Documents"
            "Videos"
            {
              directory = ".gnupg";
              mode = "0700";
            }
            {
              directory = ".ssh";
              mode = "0700";
            }
            {
              directory = ".local/share/keyrings";
              mode = "0700";
            }

            ".local/share/nix"
            ".pki"
          ];

          files = [
            ".gitconfig"
          ];
        };
      };
    };

}
