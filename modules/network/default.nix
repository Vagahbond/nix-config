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
        secretsFile = config.age.secrets.wifi.path;
        networks = {
          "@HOME_SSID@" = {
            pskRaw = "ext:HOME_PSK";
          };

          "@ESGI_SSID@" = {
            pskRaw = "ext:ESGI_PSK";
          };

          "@ESGI2_SSID@" = {
            pskRaw = "ext:ESGI2_PSK";
          };

          "@VICFI_SSID@" = {
            pskRaw = "ext:VICFI_PSK";
          };

          "@JEREM_SSID@" = {
            pskRaw = "ext:JEREM_PSK";
          };
          "@MAMIE_SSID@" = {
            pskRaw = "ext:MAMIE_PSK";
          };

          "@ZERREF_SSID@" = {
            pskRaw = "ext:ZERREF_PSK";
          };

          "@EARL_ST_SSID@" = {
            pskRaw = "ext:EARL_ST_PSK";
          };

          "@EARL_ST_2_SSID@" = {
            pskRaw = "ext:EARL_ST_2_PSK";
          };
          "@LENNOX_HEAD_SSID@" = {
            pskRaw = "ext:LENNOX_HEAD_PSK";
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
