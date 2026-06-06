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
    targets = [ "androidConfiguration" ];
    conf =
      { pkgs, ... }:
      {
        android-integration = {
          termux-setup-storage.enable = true;
          termux-open-url.enable = true;
          termux-open.enable = true;
        };

        environment.packages = systemPkgs pkgs;
      };
  }
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
        ...
      }:
      {
        environment = {
          systemPackages = with pkgs; [
            zip
            unzip
            nitch
            powertop
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
]
