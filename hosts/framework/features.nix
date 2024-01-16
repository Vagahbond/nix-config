{inputs, ...}: let
  username = import ../../username.nix;
in {
  imports = [
    ../../modules
    inputs.agenix.nixosModules.default
  ];

  config = {
    age.identityPaths = [
      "/home/${username}/.ssh/id_rsa"
    ];

    modules = {
      graphics.type = "intel";

      # monitor=eDP-1, 2256x1504@60, 0x0, 1.5
      desktop = {
        rice = "hyprland";
        screenHeight = 1504;
        screenWidth = 2256;
        screenRefreshRate = 60;
        screenScalingRatio = 1.175;
      };

      browser.firefox.enable = true;

      dev = {
        enable = true;

        enableGeo = false;
        enableNetwork = true;
        languages = ["c-cpp" "nodejs" "nix" "android"];
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
        ssh.enable = true;
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
        processManager = "htop";
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
        dofus.enable = true;
        steam.enable = false;
      };
    };
  };
}
