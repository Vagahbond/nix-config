{
  targets = [
    "air"
    "platypute"
    "framework"
  ];

  sharedConfiguration =
    { pkgs, ... }:
{
  lib,
  config,
  helpers,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  inherit (config.modules.impermanence) storageLocation;

  username = import ../../username.nix;

  cfg = config.modules.security;

in
{
  imports = [ ./options.nix ];
  config = mkMerge [
    {
      age.identityPaths = [
        "/home/${username}/.ssh/id_ed25519"
      ];

      environment = {
        systemPackages = [
          inputs.agenix.packages.${pkgs.stdenv.system}.default
        ];

      }
      // lib.optionalAttrs config.modules.impermanence.enable {
        persistence.${storageLocation} = {
          users.${username} = {
            directories = [
              ".local/share/keyring"
            ];
          };
        };
      };

      /*
        programs.gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
        };

        security.pam.services.gnupg = {
          enable = true;
          gnupg.enable = true;
        };
      */
    }
    (mkIf cfg.fingerprint.enable {
      services = lib.optionalAttrs (!(helpers.isDarwin pkgs.stdenv.system)) {
        fprintd = {
          enable = true;
        };
      };

      # keep fingerprints
      environment = lib.optionalAttrs config.modules.impermanence.enable {
        persistence.${storageLocation} = {
          directories = [
            "/var/lib/fprint"
          ];
        };
      };
    })
    /*
      (mkIf cfg.polkit.enable {
        security.polkit.enable = true;
      })
    */
  ];
}
