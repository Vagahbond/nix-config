{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  # TODO: Add ssh keys, ssh server, those kinda things
  username = import ../../username.nix;

  graphics = config.modules.graphics;

  cfg = config.modules.network;
in {
  options.modules.network = {
    wifi = {
      enable = mkEnableOption "Enable wifi";
    };

    bluetooth = {
      enable = mkEnableOption "Enable bluetooth";
    };

    ssh = {
      enableClient = mkEnableOption "Enable ssh client";
      enableServer = mkEnableOption "Enable ssh server";
    };

    debug = {
      enable = mkEnableOption "Enable debugging";
    };
  };

  # imports = [
  #   inputs.agenix.nixosModules.default
  # ];

  config = mkMerge [
    (mkIf (cfg.wifi.enable) {
      age.secrets.wifi = {
        file = ../../secrets/wifi.age;
        owner = username;
        mode = "700";
        group = "users";
      };

      networking.wireless.enable = true;
      networking.wireless.userControlled.enable = true;
      networking.wireless.environmentFile = config.age.secrets.wifi.path;
      networking.wireless.networks = {
        "@HOME_SSID@" = {
          psk = "@HOME_PSK@";
        };

        "@TETHERING_SSID@" = {
          psk = "@TETHERING_SSID@";
        };

        "@WORK1_SSID@" = {
          psk = "@WORK1_PSK@";
        };

        "@WORK2_SSID@" = {
          psk = "@WORK2_PSK@";
        };

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
      };
    })
    (mkIf (cfg.wifi.enable
      && (graphics.type != null)) {
      environment.systemPackages = with pkgs; [
        wpa_supplicant_gui
      ];
    })
    (mkIf (cfg.bluetooth.enable) {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
      };
    })
    (mkIf (cfg.ssh.enableClient) {
      environment.systemPackages = with pkgs; [
        sshs
      ];
    })
    (mkIf (cfg.debug.enable) {
      environment.systemPackages = with pkgs; [
        socat
      ];

      programs.mtr.enable = true;
    })
  ];
}
