{
  inputs,
  lib,
  ...
}: let
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

    specialisation.passthrough.configuration = {
      system.nixos.tags = ["with-vfio"];

      modules.graphics = lib.mkForce {
        type = "nvidia-passthrough";

        gpuIOMMUIds = [
          "10de:1f11"
          "10de:10f9"
          "8086:1901"
          "10de:1ada"
          "10de:1adb"
        ];
      };
    };

    modules = {
      graphics = {
        type = "nvidia-optimus";
        intel-path = "/dev/dri/card1";
        nvidia-path = "/dev/dri/card0";
      };

      desktop = {
        session = "hyprland";
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
        libvirt.enable = true;
        # virtualbox.enable = true;
        kubernetes.client.enable = false;
      };

      gaming = {
        dofus.enable = true;
        steam.enable = true;
        optimisations.enable = true;
        steering-wheel.enable = true;
        minecraft.enable = false;
        tlauncher.enable = true;
      };
    };
  };
}
