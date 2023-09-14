{lib, ...}:
with lib; {
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
}
