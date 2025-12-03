{lib, ...}:
with lib; {
  options.modules.security = {
    fingerprint = {
      enable = mkEnableOption "Fingerprint support";
    };

    polkit = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable polkit support";
        example = false;
      };
    };

    bitwarden = {
      enable = mkEnableOption "Bitwarden Client";
    };
  };
}
