# https://blog.beardhatcode.be/2020/12/Declarative-Nixos-Containers.html
{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  username = import ../../username.nix;
  hostname = config.networking.hostName;

  keys = import ../../secrets/sshKeys.nix {inherit config lib;};
  inherit (config.modules.impermanence) storageLocation;
  cfg = config.modules.services;
in {
  imports = [./options.nix];

  config = mkMerge [
    (
      mkIf cfg.proxy.enable (import ./proxy.nix {})
    )
    (
      mkIf cfg.blog.enable (import ./blog.nix {inherit storageLocation;})
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
      mkIf (cfg.nextcloud.enable && cfg.nextcloud.backup) (import ./nextcloud_backup.nix {inherit config;})
    )
  ];
}
