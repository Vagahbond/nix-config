{lib, ...}:
with lib; {
  options.modules.locales = {
    zone = mkOption {
      type = types.str;
      default = "Australia/Brisbane";
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
