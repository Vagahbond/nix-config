{
  targets = [
    "air"
    "platypute"
    "framework"
  ];

  sharedConfiguration =
    {
      pkgs,
      inputs,
      ...
    }:
    {
      nixpkgs.config = {
        allowUnfree = true;
      };

      environment = {
        # etc."current-flake".source = self;
        systemPackages = with pkgs; [
          cachix
          nh
        ];
      };

      nix = {
        optimise.automatic = true;
        settings = {
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

  nixosConfiguration =
    { username, ... }:
    {

      system = {
        autoUpgrade = {
          enable = true;
          channel = "https://nixos.org/channels/nixos-unstable";
        };
      };
      home-manager.users.${username} = {
        nixpkgs.config = {
          allowUnfree = true;
        };

      };
    };

  darwinConfiguration = _: {

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

    system.stateVersion = 6;

  };
}
