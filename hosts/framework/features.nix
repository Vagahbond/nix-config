{
  config,
  lib,
  ...
}: let
  username = import ../../username.nix;

  keys = import ../../secrets/sshKeys.nix {inherit config lib;};
in {
  config = {
    rice = "turtl-snail";

    modules = {
      impermanence.enable = true;

      graphics.type = "intel";

      # monitor=eDP-1, 2256x1504@60, 0x0, 1.5
      desktop = {
        session = "hyprland";

        widgets = {
          eww.enable = false;
          ags.enable = true;
        };

        fileExplorer = "thunar";
        notifications = "mako";
        terminal = "foot";
        displayManager = "sddm";
        launcher = "anyrun";
        wallpaper = "hyprpaper";
        lockscreen = "hyprlock";
      };

      browser = {
        firefox.enable = true;
        chromium.enable = true;
      };

      dev = {
        enable = true;

        enableGeo = false;
        enableNetwork = true;
        languages = ["c-cpp" "js" "nix" "android"];
      };

      editor = {
        gui = ["vscode"];
        terminal = ["neovim"];
        office = true;
      };

      medias = {
        video = {
          player = true;
          downloader = true;
          encoder = true;
          recorder = false;
        };

        audio = {
          player = true;
        };

        image = {
          viewer = true;
          editor = true; # need to make those sweet meems
        };
      };

      network = {
        wifi.enable = true;
        bluetooth.enable = true;
        ssh = {
          enable = true;
          keys = with keys; [
            builder_access
            platypute_access
            github_access
            dedistonks_access
          ];
        };
      };

      output = {
        audio.enable = true;
        printer.enable = true;
      };

      # Notion on nix broken for now, too busy to look into it
      productivity = {
        notion.enable = false;
        nextcloudSync.enable = true;
        pomodoro.enable = true;
        # activityWatch.enable = true;
      };

      security = {
        keyring.enable = true;
        fingerprint.enable = true;
        polkit.enable = true;
      };

      social = {
        whatsapp.enable = true;
        discord.enable = true;
        # teams.enable = true;
        matrix.enable = true;
      };

      system = {
        ntfs.enable = true;
        compression.enable = true;
      };

      terminal = {
        theFuck.enable = true;
        shell = "zsh";
      };

      virtualisation = {
        docker.enable = true;
        libvirt.enable = true;
        # virtualbox.enable = true;
        kubernetes.client.enable = true;
      };

      gaming = {
        wine.enable = true;
        dofus.enable = false;
        steam.enable = false;
      };
    };
  };
}
