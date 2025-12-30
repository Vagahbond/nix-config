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
        owner = "wpa_supplicant";
        mode = "600";
        group = "wpa_supplicant";
      };

      networking.wireless = {
        enable = true;
        userControlled.enable = true;
        secretsFile = config.age.secrets.wifi.path;
        networks = {
          "p22" = {
            pskRaw = "ext:P22_PSK";
          };
          "Telstra747AFB" = {
            pskRaw = "ext:CHINESE_MANSION_PSK";
          };

          "Trezise Nursery" = {
            pskRaw = "ext:BRANCHES_PSK";
          };

          "ESGI" = {
            pskRaw = "ext:ESGI_PSK";
          };

          "Campus ESGI" = {
            pskRaw = "ext:ESGI2_PSK";
          };

          "Freebox-5AD873" = {
            pskRaw = "ext:VICFI_PSK";
          };

          "SFR_0A88" = {
            pskRaw = "ext:JEREM_PSK";
          };

          "Livebox-EC30" = {
            pskRaw = "ext:ZERREF_PSK";
          };

          "TelstraA3CF79" = {
            pskRaw = "ext:LENNOX_HEAD_PSK";
          };

          "Raymondo's WiFi" = {
            pskRaw = "ext:RAYMOND_PSK";
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
    (mkIf cfg.vpn.enable {
      # Works with wgnord and wg-quick
      # Remember to create /var/lib/wgnord/template.conf (nix module could do that for you but I need to work rn)
      # Remember to wg-quick down and up for it to work.

      environment = {
        persistence.${impermanence.storageLocation} = {
          directories = [
            "/var/lib/wgnord"
            "/etc/wireguard/"
          ];
        };

        systemPackages = with pkgs; [
          wgnord
          wireguard-tools
        ];
      };
    })
  ];
}
