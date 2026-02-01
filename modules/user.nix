{
  targets = [
    "platypute"
    "framework"
    "air"
  ];

  sharedConfiguration = {username, ...}: {
    users = {
      users = {
        ${username} = {
          description = "Main user";
        };
      };
    };
  };

  darwinConfiguration = {username, ...}: {
    users.users.${username}.home = "/Users/${username}";
  };

  nixosConfiguration = {
    config,
    username,
    ...
  }: {
    users = {
      mutableUsers = false;
      users = {
        ${username} = {
          isNormalUser = true;
          extraGroups = ["wheel"];
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
