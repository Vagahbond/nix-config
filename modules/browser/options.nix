{ lib, ... }:
with lib;
{
  options.modules.browser = {
    firefox = {
      enable = mkEnableOption "Firefox";
    };

    librewolf = {
      enable = mkEnableOption "Librewolf";
    };

    chromium = {
      enable = mkEnableOption "chromium";
    };
  };
}
