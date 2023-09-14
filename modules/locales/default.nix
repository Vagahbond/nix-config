{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.locales;
in {
  imports = [./options.nix];
  config = {
    # Set your time zone.
    time.timeZone = cfg.zone;
    i18n.defaultLocale = cfg.language;
    i18n.extraLocaleSettings = {
      LC_ADDRESS = cfg.detailsLanguage;
      LC_IDENTIFICATION = cfg.detailsLanguage;
      LC_MEASUREMENT = cfg.detailsLanguage;
      LC_MONETARY = cfg.detailsLanguage;
      LC_NAME = cfg.detailsLanguage;
      LC_NUMERIC = cfg.detailsLanguage;
      LC_PAPER = cfg.detailsLanguage;
      LC_TELEPHONE = cfg.detailsLanguage;
      LC_TIME = cfg.detailsLanguage;
    };
  };
}
