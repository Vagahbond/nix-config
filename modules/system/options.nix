{lib, ...}:
with lib; {
  options.modules.system = {
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
