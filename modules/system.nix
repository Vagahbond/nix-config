[
  {
    targets = [ "androidConfiguration" ];
    conf = _: {
      android-integration = {
        termux-setup-storage.enable = true;
        android-integration.termux-open-url.enable = true;
        android-integration.termux-open.enable = true;
      };
    };
  }
  {
    targets = [
      "nixosConfiguration"
      "darwinConfiguration"
      "androidConfiguration"
    ];
    conf =
      { pkgs, ... }:
      {
        config = {
          environment.systemPackages = with pkgs; [
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
          ];
        };
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
