{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  # TODO: Add ssh keys, ssh server, those kinda things
  username = import ../../username.nix;

  inherit (config.modules) graphics impermanence;

  cfg = config.modules.network;
in {
  imports = [./options.nix];
  # imports = [
  #   inputs.agenix.nixosModules.default
  # ];

  config = mkMerge [
    (mkIf cfg.wifi.enable {
      age.secrets.wifi = {
        file = ../../secrets/wifi.age;
        owner = username;
        mode = "600";
        group = "users";
      };

      networking.wireless = {
        enable = true;
        userControlled.enable = true;
        environmentFile = config.age.secrets.wifi.path;
        networks = {
          "@HOME_SSID@" = {
            psk = "@HOME_PSK@";
          };

          "@ESGI_SSID@" = {
            psk = "@ESGI_PSK@";
          };

          "@ESGI2_SSID@" = {
            psk = "@ESGI2_PSK@";
          };

          "@VICFI_SSID@" = {
            psk = "@VICFI_PSK@";
          };

          "@JEREM_SSID@" = {
            psk = "@JEREM_PSK@";
          };
          "@MAMIE_SSID@" = {
            psk = "@MAMIE_PSK@";
          };

          "@ZERREF_SSID@" = {
            psk = "@ZERREF_PSK@";
          };

          "@EARL_ST_SSID@" = {
            psk = "@EARL_ST_PSK@";
          };

          "@EARL_ST_2_SSID@" = {
            psk = "@EARL_ST_2_PSK@";
          };
        };
      };
    })
    (mkIf (cfg.wifi.enable
      && (graphics.type != null)) {
      environment.systemPackages = with pkgs; [
        wpa_supplicant_gui
      ];
    })
    (mkIf cfg.bluetooth.enable {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
      };

      services.blueman.enable = true;

      # keep paired peripherals
      environment.persistence.${impermanence.storageLocation} = {
        directories = [
          "/var/lib/bluetooth"
        ];
      };
    })
    (
      mkIf cfg.ssh.enable
      (import ./ssh.nix {inherit lib config pkgs username;})
    )
    (mkIf cfg.debug.enable {
      environment.systemPackages = with pkgs; [
        socat
      ];

      programs.mtr.enable = true;
    })
  ];
}
