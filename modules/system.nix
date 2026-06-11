let
  systemPkgs =
    pkgs:
    (with pkgs; [
      fzf
      tealdeer
      bat
      dust
      tree
      killall
      htop
      jq
      socat
      rclone
    ]);
in
[
  {
    targets = [
      "nixosConfiguration"
      "darwinConfiguration"
    ];
    conf =
      { pkgs, ... }:
      {
        environment.systemPackages = systemPkgs pkgs;
      };
  }

  {
    targets = [ "nixosConfiguration" ];
    conf =
      {
        pkgs,
        config,
        username,
        libUtils,
        ...
      }:
      {
        environment = {
          systemPackages =
            with pkgs;
            [
              zip
              unzip
              nitch
              powertop
              lz4
              ntfs3g
              systemctl-tui
            ]
            ++ (libUtils.ifSupported config rar);

          persistence.${config.persistence.storageLocation} = {
            users.${username} = {
              directories = [
                ".config/rclone"
              ];
            };
          };
        };

        programs.appimage = {
          enable = true;
          binfmt = true;
        };
      };
  }
]
