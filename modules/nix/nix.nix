let
  nhEnv = {
    NH_FLAKE = "git+ssh://forgejo@git.vagahbond.com/vagahbond/nix-config.git";
  };
in
[
  {
    targets = [
      "nixosConfiguration"
      "darwinConfiguration"
    ];
    conf =
      {
        pkgs,
        inputs,
        username,
        ...
      }:
      {

        environment = {
          # etc."current-flake".source = self;
          systemPackages = with pkgs; [
            cachix
            nh
          ];
        };

        nixpkgs.config = {
          allowUnfree = true;
        };

        nix = {

          optimise.automatic = true;
          settings = {

            substituters = [ "https://cache.nixos.org/" ];
            trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            trusted-users = [
              username
              "root"
            ];

            # auto-GC mid-build/eval when store gets low, instead of failing with ENOSPC
            min-free = 10 * 1024 * 1024 * 1024; # 5G
            # max-free = 1 * 1024 * 1024 * 1024; # 15G

            keep-outputs = false;
            keep-derivations = false;

          };

          gc = {
            automatic = true;
            # interval = "weekly";
            options = "--delete-older-than 1d";
          };

          registry = pkgs.lib.mkDefault (pkgs.lib.mapAttrs (_: value: { flake = value; }) inputs);

        };
      };

  }

  {
    targets = [ "nixosConfiguration" ];
    conf = _: {
      system = {
        autoUpgrade = {
          enable = true;
          channel = "https://nixos.org/channels/nixos-unstable";
        };
      };

      systemd = {
        tmpfiles.rules = [
          "d /var/tmp/nix 1777 root root 10d"
        ];
      };

      environment.sessionVariables = {
        TMPDIR = "/var/tmp"; # Use a disk-based directory
      }
      // nhEnv;

    };
  }
  {
    targets = [ "darwinConfiguration" ];
    conf = { username, pkgs, ... }: {
      # https://github.com/nix-darwin/nix-darwin/issues/1817
      documentation.enable = false;
      system.tools.darwin-uninstaller.enable = false;

      environment.variables = {
        NIXPKGS_ALLOW_UNFREE = "1";
      }
      // nhEnv;

      nix = {
        linux-builder = {
          enable = true;
          speedFactor = 3;
          ephemeral = false;
          maxJobs = 4;
          systems = [
            "aarch64-linux"
          ];
        };

        settings.trusted-users = [
          username
          "root"
        ];
      };

      # TODO: remove
      system.stateVersion = 6;
    };
  }
]
