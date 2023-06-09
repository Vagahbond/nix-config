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

      desktop = "hyprland";

      browser.firefox.enable = true;

      dev = {
        enable = true;

        enableGeo = true;
        enableNetwork = true;

        languages = ["c-cpp" "nodejs" "nix"];
      };

      editor = {
        gui = ["vscode"];
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
        ssh.enableClient = true;
      };

      output = {
        audio.enable = true;
        printer.enable = true;
      };

      # Soon to be agremented with other options I guess
      productivity.notion.enable = true;

      security = {
        keyring.enable = true;
        fingerprint.enable = true;
        polkit.enable = true;
      };

      social = {
        whatsapp.enable = true;
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
        docker.enable = true;
        libvirt.enable = true;
        # virtualbox.enable = true;
        kubernetes.client.enable = true;
      };
    };
  };
}
