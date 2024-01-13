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

          /*
          "@WORK3_SSID@" = {};

          #oof, better change scheme there
          "@GF_SSID0@" = {
            psk = "@GF_PSK0@";
          };

          "@GF_SSID1@" = {};

          "@GF_SSID2@" = {
            psk = "@GF_PSK2@";
          };

          "@GF_SSID3@" = {
            psk = "@GF_PSK3@";
          };

          "@IDK_SSID1@" = {
            psk = "@IDK_PSK1@";
          };

          "@IDK_SSID2@" = {
            psk = "@IDK_PSK2@";
          };
          */
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

      # keep paired peripherals
      environment.persistence.${impermanence.storageLocation} = {
        directories = [
          "/var/lib/bluetooth"
        ];
      };
    })
    (mkIf cfg.ssh.enable {
      environment.systemPackages = with pkgs; [
        sshs
      ];

      age.secrets.sshConfig = {
        file = ../../secrets/ssh_config.age;
        path = "${config.users.users.${username}.home}/.ssh/config";
        owner = username;
        group = "users";
      };
    })
    (mkIf cfg.debug.enable {
      environment.systemPackages = with pkgs; [
        socat
      ];

      programs.mtr.enable = true;
    })
  ];
}
