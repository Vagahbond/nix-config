
{
  targets = [
    "air"
    "platypute"
    "framework"
  ];

  sharedConfiguration =
    { pkgs, ... }:
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

