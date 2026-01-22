# TODO: break this down into modules
{
  targets = [
    "air"
    "platypute"
    "framework"
  ];

  sharedConfiguration =
    {
      pkgs,
      ...
    }:
    {
      config = {
        environment.systemPackages = with pkgs; [
          fzf
          tealdeer
          bat
          dust
          powertop
          tree
          killall
          htop
          jq
          nitch
          socat
          rclone
        ];

      };
    };

  nixosConfiguration =
    {
      pkgs,
      config,
      username,
      ...
    }:
    {
      environment = {
        systemPackages = with pkgs; [
          zip
          unzip
          rar
          lz4
          ntfs3g
          systemctl-tui
        ];
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
