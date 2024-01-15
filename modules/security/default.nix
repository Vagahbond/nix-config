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
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    }
    (mkIf cfg.keyring.enable {
      # TODO: add seahorse
      services.gnome.gnome-keyring.enable = true;
    })
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
