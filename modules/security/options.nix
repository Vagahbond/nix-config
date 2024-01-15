{lib, ...}:
with lib; {
  options.modules.security = {
    keyring = {
      enable = mkEnableOption "Keyring";
    };

    fingerprint = {
      enable = mkEnableOption "Fingerprint support";
    };

    polkit = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable polkit support";
        example = false;
      };
    };

    bitwarden = {
      enable = mkEnableOption "Bitwarden Client";
    };
  };
}
