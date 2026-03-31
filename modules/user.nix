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
    let

      fileModule = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            source = lib.mkOption {
              type = lib.types.path;
              description = "Path to the file in the nix store.";
            };
            text = lib.mkOption {
              type = lib.types.str;
              description = "Content for the file";
            };
          };
        }
      );

      homeFileModule = lib.mkOption {
        description = "A module allowing to create files and symlink them in the home directory";
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = fileModule;
          }
        );
      };

      mkSymlinks =
        links:
        lib.concatStringsSep "\n" (
          lib.mapAttrsToList (dest: src: ''
            mkdir -p "$(${pkgs.coreutils}/bin/dirname ${dest})"
            ln -sf ${src} ${dest}
          '') links
        );
    in
    {
      options.home-files = homeFileModule;
      # {
      #   home-files = lib.mkOption {
      #   type = lib.types.attrsOf (
      #     lib.types.submodule {
      #       options = {
      #         files = lib.mkOption {
      #           type = lib.attrsOf fileModule;
      #           default = { };
      #           description = "Attribute set of files to symlink, keyed by relative path to $HOME";
      #         };
      #       };
      #     }
      #   );
      # };
      #  };

      config = {

        system.activationScripts.homeFiles.text = lib.concatStringsSep "\n" (
          lib.mapAttrsToList (
            username: userCfg:
            let
              inherit (config.users.users.${username}) home;
              links = lib.mapAttrs' (
                relPath: fileCfg:
                lib.nameValuePair "${home}/${relPath}" (fileCfg.source or (pkgs.writeText relPath fileCfg.text))
              ) userCfg;
            in
            mkSymlinks links
          ) config.home-files
        );

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
