[
  {
    targets = [ "androidConfiguration" ];

    conf =
      { pkgs,  ... }:
      {
        environment.packages = with pkgs; [
          cachix
        ];
      };

  }
  {
    targets = [
      "nixosConfiguration"
      "darwinConfiguration"
    ];
    conf =
      {
        pkgs,
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
      };
  }

  {
    targets = [
      "nixosConfiguration"
      "darwinConfiguration"
    ];
    conf =
      { pkgs, inputs, ... }:
      {

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
              "root"
            ];

          };

          gc = {
            automatic = true;
            # interval = "weekly";
            options = "--delete-older-than 2d";
          };

          registry = pkgs.lib.mkDefault (pkgs.lib.mapAttrs (_: value: { flake = value; }) inputs);

        };
      };

  }

  {
    targets = [ "androidConfiguration" ];
    conf =
      { pkgs, inputs, ... }:
      {
        nix = {

          substituters = [ "https://cache.nixos.org/" ];
          trustedPublicKeys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
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
      };

    };
  }
  {
    targets = [ "darwinConfiguration" ];
    conf = _: {
      environment.variables = {
        NIXPKGS_ALLOW_UNFREE = "1";
      };

      nix = {
        linux-builder = {
          enable = true;
          ephemeral = true;
          maxJobs = 4;
          config = {
            virtualisation = {
              darwin-builder = {
                diskSize = 40 * 1024;
                memorySize = 8 * 1024;
              };
              cores = 6;
            };
          };
        };

        settings.trusted-users = [ "@admin" ];
      };

      # TODO: remove
      system.stateVersion = 6;
    };
  }
]
