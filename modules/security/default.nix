{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
with lib; let
  graphics = config.modules.graphics;

  cfg = config.modules.security;
in {
  options.modules.security = {
    keyring = {
      enable = mkEnableOption "Keyring";
    };

    fingerprint = {
      enable = mkEnableOption "Fingerprint support";
    };

    polkit = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable polkit support";
        example = false;
      };
    };
  };

  config =
    {
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    }
    // mkIf cfg.keyring.enable {
      # TODO: add seahorse
      services.gnome.gnome-keyring.enable = true;
    }
    // mkIf cfg.fingerprint.enable {
      services.fprintd = {
        enable = true;
      };
    }
    // mkIf cfg.polkit.enable {
      security.polkit.enable = true;
    };
}
