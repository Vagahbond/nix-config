{config, ...}: let
  username = import ./username.nix;
  inherit (config.modules.impermanence) storageLocation;
in {
  users = {
    mutableUsers = false;
    users = {
      root = {
        initialPassword = "root";
      };

      ${username} = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        home = "/home/${username}";
        description = "My only user. Ain't no one else using my computer. Fuck you.";
        initialPassword = username;
        passwordFile = "/nix/persistent/passwords/${username}";
      };
    };
  };

  environment.persistence.${storageLocation} = {
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
        ".local/share"
        ".pki"
      ];

      files = [
        ".gitconfig"
      ];
    };
  };
}
