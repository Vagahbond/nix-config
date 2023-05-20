{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.locales;
in {
  options.modules.locales = {
    zone = mkOption {
      type = types.str;
      default = "Europe/Paris";
      description = ''        The time zone to use. 
              Your real location is relevant for SSL certificates, 
              so you should set this to your real location.'';
      example = "Europe/Paris";
    };

    language = mkOption {
      type = types.str;
      default = "en_US.utf8";
      description = ''The default language to use.'';
      example = "en_US.utf8";
    };

    detailsLanguage = mkOption {
      type = types.str;
      default = "fr_FR.utf8";
      description = ''        The language to use for formatting specific things :
              - dates
              - numbers
              - currency
              - addresses
              - measurements
              - paper sizes
              - telephone numbers
              - time'';
      example = "en_US.utf8";
    };
  };

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
