
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.modules.impermanence) enable storageLocation;
in
{
  imports = [
    ./options.nix
  ];

  config = {
    environment = lib.optionalAttrs enable {
      persistence.${storageLocation} = {
        directories = [
          "/var/cache"
          "/var/log"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
        ];
        files = [
          #  "/etc/machine-id"
        ];
      };
    };
  };
}
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
