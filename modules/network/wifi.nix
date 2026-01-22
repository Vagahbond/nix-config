(mkIf cfg.wifi.enable {

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
  age.secrets.wifi = {
    file = ../../secrets/wifi.age;
    owner = "wpa_supplicant";
    mode = "600";
    group = "wpa_supplicant";
  };

})
