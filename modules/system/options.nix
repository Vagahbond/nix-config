{lib, ...}:
with lib; {
  options.modules.system = {
    processManager = mkOption {
      type = types.enum ["htop" "btop"];
      default = "htop";
      description = ''
        Select the process manager to use.
      '';
      example = "btop";
    };

    ntfs.enable = mkEnableOption "NTFS support";

    compression.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable compression tools.
      '';
      example = false;
    };
  };
}
