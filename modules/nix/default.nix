{
  pkgs,
  lib,
  config,
  self,
  inputs,
  helpers,
  ...
}:
with lib;
let
  cfg = config.modules.nix;
  #  persistenceCfg = config.modules.impermanence;
  username = import ../../username.nix;
in
{
  imports = [ ./options.nix ];
  config = mkMerge [
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

        registry = lib.mkDefault (lib.mapAttrs (_: value: { flake = value; }) inputs);
      };
    }
    /*
      (
        mkIf (!(helpers.isDarwin pkgs.stdenv.system)) {
          system = {
            stateVersion = "22.11"; # Did you read the comment?
            autoUpgrade = {
              enable = true;
              channel = "https://nixos.org/channels/nixos-unstable";
            };
          };
        }
        // lib.optionalAttrs (builtins.hasAttr "home-manager" options) {
          home-manager.users.${username} = {
            nixpkgs.config = {
              allowUnfree = true;
            };

            home.stateVersion = "22.11";
          };
        }
      )
    */

    (mkIf (helpers.isDarwin pkgs.stdenv.system) {
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

    })
    (mkIf cfg.remoteBuild.enable {

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
            supportedFeatures = [
              "nixos-test"
              "benchmark"
              "big-parallel"
              "kvm"
            ];
          }
        ];

        distributedBuilds = true;
        extraOptions = ''
          builders-use-substitutes = true
        '';
      };
    }
      /*
        // lib.optionalAttrs persistenceCfg.enable {
          persistence.${config.modules.impermanence.storageLocation} = {
            directories = [ "/root/.ssh" ];
          };
        }
      */
    )
  ];
}
