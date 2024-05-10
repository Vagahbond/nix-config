{
  lib,
  config,
  ...
}: let
  keys = import ../../secrets/sshKeys.nix {inherit lib config;};
in
  with lib; {
    options.modules.network = {
      wifi = {
        enable = mkEnableOption "wifi";
      };

      bluetooth = {
        enable = mkEnableOption "bluetooth";
      };

      ssh = {
        enable = mkEnableOption "ssh client";
        keys = mkOption {
          description = "Installed SSH keys";
          default = [];
          type = types.listOf (types.attrs);
          example = [keys.dedistonks_access];
        };
      };

      debug = {
        enable = mkEnableOption "debugging";
      };
    };
  }
