{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  username = import ../../username.nix;

  inherit (config.modules) graphics impermanence;

  cfg = config.modules.output;
in {
  imports = [./options.nix];
  config = mkMerge [
    (mkIf cfg.audio.enable {
      # Enable sound with pipewire.
      sound = {
        enable = true;
        mediaKeys.enable = true;
      };

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

      users.users.${username}.extraGroups = ["audio"];

      # keep volume state
      environment.persistence.${impermanence.storageLocation} = {
        directories = [
          "/var/lib/alsa"
        ];
      };
    })
    (mkIf (cfg.audio.enable && graphics != null) {
      environment.systemPackages = with pkgs; [
        pavucontrol
      ];
    })
    (mkIf cfg.printer.enable {
      services.printing.enable = true;

      # Keep registered printers
      environment.persistence.${impermanence.storageLocation} = {
        directories = [
          "/var/lib/cups"
        ];
      };
    })
  ];
}
