{
  inputs,
  config,
  lib,
  ...
}: let
  inherit (config.modules.impermanence) enable storageLocation;
in {
  imports = [
    inputs.impermanence.nixosModule
    ./options.nix
  ];

  config = {
    environment.persistence =
      if enable
      then {
        ${storageLocation} = {
          directories = [
            "/var/log"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
          ];
          files = [
            #  "/etc/machine-id"
          ];
        };
      }
      else lib.mkForce {};
  };
}
