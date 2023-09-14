{lib, ...}:
with lib; {
  options.modules.browser.firefox = {
    enable = mkOption {
      type = types.bool;
      description = "Enable or not Firefox. Enabled by default.";
      default = true;
      example = false;
    };
  };
}
