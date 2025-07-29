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
    inputs.learnify.nixosModules.default
    ./options.nix
  ];

  config = mkMerge [
    (
      mkIf cfg.proxy.enable (import ./proxy.nix {})
    )
    (
      mkIf cfg.invoices.enable (import ./invoices.nix {inherit storageLocation config;})
    )
    (
      mkIf cfg.blog.enable (import ./blog.nix {inherit config pkgs inputs;})
    )
    (
      mkIf cfg.pdf.enable (import ./pdf.nix {inherit storageLocation config;})
    )
    (
      mkIf cfg.ssh.enable (import ./ssh.nix {inherit username hostname keys;})
    )
    (
      mkIf cfg.homePage.enable (import ./homepage.nix {inherit pkgs inputs;})
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
      mkIf cfg.office.enable (import ./office.nix {inherit storageLocation config pkgs;})
    )
    (
      mkIf cfg.notes.enable (import ./notes.nix {inherit storageLocation config pkgs inputs;})
    )
    (
      mkIf cfg.fitness.enable (
        import ./fitness.nix {inherit storageLocation config pkgs inputs;}
      )
    )
    (
      mkIf cfg.universe.enable (import ./universe.nix {inherit config pkgs inputs;})
    )
    (
      mkIf cfg.learnify.enable (import ./learnify.nix {inherit config pkgs inputs;})
    )
    (
      mkIf cfg.metrics.enable (import ./metrics.nix {inherit storageLocation config pkgs inputs;})
    )
    (
      mkIf cfg.cockpit.enable {
        services.cockpit = {
          enable = true;
          settings = {
            WebService = {
              Origins = "https://cockpit.vagahbond.com wss://cockpit.vagahbond.com";
              ProtocolHeader = "X-Forwarded-Proto";
            };
          };
        };

        services.nginx.virtualHosts."cockpit.vagahbond.com" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:9090";
            proxyWebsockets = true; # needed if you need to use WebSocket
          };
        };
      }
    )
  ];
}
