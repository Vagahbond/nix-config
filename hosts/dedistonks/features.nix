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
      graphics.type = null;

      browser.firefox.enable = false;

      dev = {
        enable = true;

        enableGeo = false;
        enableNetwork = false;

        languages = ["nix"];
      };

      editor = {
        gui = [];
        terminal = ["neovim"];
      };

      medias = {
        video = {
          player = false;
          downloader = false;
          encoder = false;
          recorder = false;
        };

        audio = {
          player = false;
        };

        image = {
          viewer = false;
          editor = false;
        };
      };

      network = {
        wifi.enable = false;
        bluetooth.enable = false;
        ssh.enableClient = false;
        #  ssh.server = true;
      };

      output = {
        audio.enable = false;
        printer.enable = false;
      };

      # Notion on nix broken for now, too busy to look into it
      productivity.notion.enable = false;

      security = {
        keyring.enable = true;
        fingerprint.enable = false;
        polkit.enable = false;
      };

      social = {
        whatsapp.enable = false;
        discord.enable = false;
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
        virtualbox.enable = false;
        kubernetes.client.enable = false;
      };

      gaming = {
        dofus.enable = false;
        steam.enable = false;
        minecraft.enable = false;
        tlauncher.enable = false;
      };
    };
  };
}
