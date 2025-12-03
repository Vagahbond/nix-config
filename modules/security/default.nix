{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  inherit (config.modules.impermanence) storageLocation;

  username = import ../../username.nix;

  cfg = config.modules.security;
in {
  imports = [./options.nix];
  config = mkMerge [
    {
      environment = {
        persistence.${storageLocation} = {
          users.${username} = {
            directories = [
              ".local/share/keyring"
            ];
          };
        };
      };

      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      security.pam.services.gnupg = {
        enable = true;
        gnupg.enable = true;
      };
    }
    (mkIf cfg.fingerprint.enable {
      services.fprintd = {
        enable = true;
      };

      # keep fingerprints
      environment.persistence.${storageLocation} = {
        directories = [
          "/var/lib/fprint"
        ];
      };
    })
    (mkIf cfg.polkit.enable {
      security.polkit.enable = true;
    })
    (mkIf cfg.bitwarden.enable {
      environment.systemPackages = with pkgs; [
        bitwarden
      ];

      environment.persistence.${storageLocation} = {
        users.${username} = {
          directories = [
            #  ""
          ];
        };
      };
    })
  ];
}
