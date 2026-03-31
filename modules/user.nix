{
  targets = [
    "platypute"
    "framework"
    "air"
  ];

  sharedConfiguration =
    {
      config,
      username,
      lib,
      pkgs,
      ...
    }:
    {

      config = {

        system.activationScripts = builtins.mapAttrs (
          un: uv:
          builtins.mapAttrs (fn: fv: {
            name = "symlink-${un}-${fn}";
            value = {
              text = ''
                mkdir -p ${config.users.users.${un}.home}/${fn}
                ln -sf ${fn.source} ${users.users.${un}.home}/${fn}
              '';
            };
          }

          ) config.users.users.${u}.files
        ) config.users.users;

        users = {
          users = {
            ${username} = {
              description = "Main user";
            };
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
    {
      config,
      username,
      ...
    }:
    {
      users = {
        mutableUsers = false;
        users = {
          ${username} = {
            isNormalUser = true;
            extraGroups = [ "wheel" ];
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
