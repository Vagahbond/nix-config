{lib, ...}:
with lib; {
  options.modules.impermanence = {
    enable = mkEnableOption "Enable impermanence for this device";
    storageLocation = mkOption {
      type = types.str;
      description = "Name of the path to persistent storage.";
      default = "/nix/persistent";
      example = "/path/to/storage";
    };
  };
}
