{lib, ...}:
with lib; {
  options.modules.browser = {
    firefox = {
      enable = mkEnableOption "Firefox";
    };

    chromium = {
      enable = mkEnableOption "chromium";
    };
  };
}
