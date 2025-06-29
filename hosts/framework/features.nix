{
  config,
  lib,
  ...
}: let
  keys = import ../../secrets/sshKeys.nix {inherit config lib;};
in {
  # Testing Cosmic
  config = {
    nix.settings = {
      substituters = ["https://cosmic.cachix.org/"];
      trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
    };

    rice = "eye-burner-minimal";
    modules = {
      impermanence.enable = true;

      user.password = "$y$j9T$ofYLQRbiSsTERtHKAoi.J1$XW1xU541EsKvdMc3WNMEliNvUn4tVxKl99PbSB5gUg/";

      graphics.type = "intel";

      # monitor=eDP-1, 2256x1504@60, 0x0, 1.5
      desktop = {
        session = "hyprland";

        ags.enable = true;

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
        godot.enable = false;

        enableGeo = false;
        enableNetwork = true;
        languages = ["c-cpp" "js" "nix" "android"];
        dbAdmin.enable = true;
      };

      editor = {
        gui = [];
        terminal = ["neovim"];
        office = true;
      };

      medias = {
        video = {
          player = true;
          downloader = true;
          recorder = false;
          editor = false;
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
        vpn.enable = true;
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
        nextcloudSync.enable = false;
        pomodoro.enable = true;
        activityWatch.enable = true;
        logseq.enable = false;
        maps.enable = false;
        musicProduction.enable = false;
      };

      security = {
        keyring.enable = true;
        fingerprint.enable = true;
        polkit.enable = true;
      };

      social = {
        whatsapp.enable = false;
        discord.enable = true;
        # teams.enable = true;
        # matrix.enable = true;
      };

      system = {
        ntfs.enable = true;
        compression.enable = true;
      };

      terminal = {
        tmux.enable = true;
        shell = "zsh";
        shellAliases = {
          rebuild-remote = ''            f() {  \
                     NIX_SSHOPTS="-i ~/.ssh/$1_access " \
                     nixos-rebuild switch --sudo --ask-sudo-password \
                     --flake .#"$1" --target-host $1 \
                     --build-host $1 --show-trace \
                     }; f\
          '';
        };
      };

      virtualisation = {
        docker.enable = true;
        libvirt.enable = true;
        wine.enable = false;
        # virtualbox.enable = true;
        kubernetes.client.enable = false;
      };

      gaming = {
        wine.enable = false;
        dofus.enable = false;
        steam.enable = false;
        lutris.enable = false;
      };
    };
  };
}
