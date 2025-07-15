{
  pkgs,
  lib,
  config,
  self,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.nix;
  username = import ../../username.nix;
in {
  imports = [./options.nix];
  config = mkMerge [
    {
      nixpkgs.config = {
        allowUnfree = true;
      };

      programs.nh = {
        enable = true;
        flake = "/home/${username}/Projects/nixos-config";
      };

      environment = {
        etc."current-flake".source = self;
      };

      environment = {
        systemPackages = with pkgs; [
          cachix
          inputs.agenix.packages.${system}.default
          #   sed
        ];
      };

      nix.registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

      age.identityPaths = [
        "${config.modules.impermanence.storageLocation}/home/${username}/.ssh/id_ed25519"
      ];

      nix = {
        settings = {
          experimental-features = ["nix-command" "flakes"];
          auto-optimise-store = true;
          trusted-users = [
            "root"
          ];
        };

        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 2d";
        };
      };

      home-manager.users.${username} = {
        nixpkgs.config = {
          allowUnfree = true;
        };

        home.stateVersion = "22.11";
      };

      system = {
        stateVersion = "22.11"; # Did you read the comment?
        autoUpgrade = {
          enable = true;
          channel = "https://nixos.org/channels/nixos-unstable";
        };
      };
    }
    (mkIf cfg.remoteBuild.enable {
      /*
         age.secrets.builder_access = {
        file = ./secrets/builder_access.age;
        path = "${config.users.users.${username}.home}/.ssh/builder_access";
        mode = "600";
        owner = username;
        group = "users";
      };
      */
      nix = {
        settings.trusted-users = [
          "builder"
        ];

        ###############################################################
        # Setup distributed builds                                    #
        ###############################################################
        buildMachines = [
          {
            hostName = "vagahbond.com";
            sshUser = "builder";
            sshKey = config.age.secrets.builder_access.path;
            system = "x86_64-linux";
            protocol = "ssh";
            maxJobs = 4;
            speedFactor = 2;
            supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
            # mandatoryFeatures = [];
          }
        ];

        distributedBuilds = true;
        extraOptions = ''
          builders-use-substitutes = true
        '';
      };
    })
  ];
}
