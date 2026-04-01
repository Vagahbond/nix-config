let

  mkHomeFilesActivationScript =
    pkgs: files: cfgUsers:
    let
      mkSymlinks =
        links:
        pkgs.lib.concatStringsSep "\n" (
          pkgs.lib.mapAttrsToList (dest: src: ''
            mkdir -p "$(${pkgs.coreutils}/bin/dirname ${dest})"
            ln -sf ${src} ${dest}
          '') links
        );
    in
    pkgs.lib.concatStringsSep "\n" (
      pkgs.lib.mapAttrsToList (
        username: userCfg:
        let
          links = pkgs.lib.mapAttrs' (
            relPath: fileCfg:
            let
              inherit (cfgUsers.${username}) home;
              sourcePath = fileCfg.source or null;
              textContent = fileCfg.text or null;
            in
            pkgs.lib.nameValuePair "${home}/${relPath}" (
              if sourcePath != null then
                sourcePath
              else if textContent != null then
                pkgs.writeText relPath textContent
              else
                throw ""
            )
          ) userCfg;
        in
        mkSymlinks links
      ) files
    );

in
{
  targets = [
    "platypute"
    "framework"
    "air"
  ];

  sharedConfiguration =
    {
      username,
      lib,
      pkgs,
      ...
    }:
    let
      fileModule = pkgs.lib.types.submodule {
        options = {
          source = pkgs.lib.mkOption {
            type = pkgs.lib.types.nullOr pkgs.lib.types.path;
            default = null;
            description = "Path to the file in the nix store.";
          };
          text = pkgs.lib.mkOption {
            type = pkgs.lib.types.nullOr pkgs.lib.types.lines;
            default = null;
            description = "Inline text content for the file.";
          };
        };
      };
    in
    {
      options.home-files = lib.mkOption {
        type = lib.types.attrsOf (lib.types.attrsOf fileModule);
        default = { };
        description = "Per-user file symlink configuration, keyed by username then relative path from home.";
      };

      config = {

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
    {
      username,
      pkgs,
      config,
      lib,
      ...
    }:
    {

      system.activationScripts.postActivation.text = lib.mkAfter (
        mkHomeFilesActivationScript pkgs config.home-files config.users.users
      );

      users.users.${username}.home = "/Users/${username}";
    };

  nixosConfiguration =
    {
      config,
      username,
      pkgs,
      ...
    }:
    {
      system.activationScripts.homeFiles = {
        text = mkHomeFilesActivationScript pkgs config.home-files config.users.users;
        deps = [ ];
      };

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
