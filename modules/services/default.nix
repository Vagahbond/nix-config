# https://blog.beardhatcode.be/2020/12/Declarative-Nixos-Containers.html
{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  username = import ../../username.nix;
  hostname = config.networking.hostName;

  keys = import ../../secrets/sshKeys.nix {inherit config lib;};
  inherit (config.modules.impermanence) storageLocation;
  cfg = config.modules.services;
in {
  # TODO: move this import to the uni-verse part somehow.
  imports = [
    inputs.universe.nixosModules.default
    ./options.nix
  ];

  config = mkMerge [
    (
      mkIf cfg.proxy.enable (import ./proxy.nix {})
    )
    (
      mkIf cfg.blog.enable (import ./blog.nix {inherit storageLocation config;})
    )
    (
      mkIf cfg.ssh.enable (import ./ssh.nix {inherit username hostname keys;})
    )
    (
      mkIf cfg.homePage.enable (import ./homepage.nix {inherit pkgs;})
    )
    (
      mkIf cfg.builder.enable (import ./builder.nix {inherit keys;})
    )
    (
      mkIf cfg.postgres.enable (import ./postgres.nix {inherit lib pkgs storageLocation;})
    )
    (
      mkIf cfg.vaultwarden.enable (import ./vaultwarden.nix {inherit storageLocation;})
    )
    (
      mkIf cfg.nextcloud.enable (import ./nextcloud.nix {inherit storageLocation config pkgs;})
    )
    (
      # DISABLED FOR NOW, DATA IS NOT BACKED UP
      mkIf (cfg.nextcloud.enable && cfg.nextcloud.backup)
      (import ./nextcloud_backup.nix {inherit config;})
    )
    (
      mkIf cfg.universe.enable (import ./universe.nix {inherit config pkgs inputs;})
    )
  ];
}
