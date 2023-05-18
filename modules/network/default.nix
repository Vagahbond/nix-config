{
  pkgs,
  config,
  inputs,
  ...
}: let
  username = import ../../username.nix;
in {
  imports = [
    inputs.agenix.nixosModules.default
  ];

  age.secrets.wifi = {
    file = ../../secrets/wifi.age;
    owner = username;
    mode = "700";
    group = "users";
  };

  environment.systemPackages = with pkgs; [
    socat
    sshs

    wpa_supplicant_gui
  ];

  programs.mtr.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

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

  networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;
  networking.wireless.environmentFile = config.age.secrets.wifi.path;
}
