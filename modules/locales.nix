
{
  targets = [
    "air"
    "platypute"
    "framework"
  ];

  sharedConfiguration =
    { pkgs, ... }:
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
      LANGUAGE = cfg.detailsLanguage;
      LC_ALL = cfg.detailsLanguage;
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
{lib, ...}:
with lib; {
  options.modules.locales = {
    zone = mkOption {
      type = types.str;
      default = "Pacific/Auckland";
      description = ''        The time zone to use. 
              Your real location is relevant for SSL certificates, 
              so you should set this to your real location.'';
      example = "Europe/Paris";
    };

    language = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
      description = ''The default language to use.'';
      example = "en_US.UTF-8";
    };

    detailsLanguage = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
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
}
