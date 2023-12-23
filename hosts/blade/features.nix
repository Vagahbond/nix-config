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
      graphics = {
        type = "nvidia-optimus";
        intel-path = "/dev/dri/card1";
        nvidia-path = "/dev/dri/card0";
      };

      desktop = {
        rice = "hyprland";
        screenHeight = 1080;
        screenWidth = 1920;
        screenRefreshRate = 144;
        screenScalingRatio = 1.0;
      };

      browser.firefox.enable = true;

      dev = {
        enable = true;

        enableGeo = false;
        enableNetwork = true;

        languages = ["nix"];
      };

      editor = {
        gui = [];
        terminal = ["neovim"];
      };

      medias = {
        video = {
          player = true;
          downloader = true;
          encoder = true;
          recorder = true;
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
        printer.enable = false;
      };

      # Notion on nix broken for now, too busy to look into it
      productivity.notion.enable = false;

      security = {
        keyring.enable = true;
        fingerprint.enable = false;
        polkit.enable = true;
      };

      social = {
        whatsapp.enable = false;
        discord.enable = true;
        # teams.enable = true;
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
        docker.enable = false;
        libvirt.enable = false;
        # virtualbox.enable = true;
        kubernetes.client.enable = false;
      };

      gaming = {
        dofus.enable = true;
        steam.enable = true;
        optimisations.enable = true;
        steering-wheel.enable = true;
        minecraft.enable = true;
        tlauncher.enable = true;
      };
    };
  };
}
