{lib, ...}:
with lib; {
  options.modules.system = {
    ntfs.enable = mkEnableOption "NTFS support";

    compression.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable compression tools.
      '';
      example = false;
    };
  };
}
