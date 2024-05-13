{
  config,
  hostConfig,
  pkgs,
  lib,
  ...
}: let
  proxiedServicesSet =
    lib.attrsets.filterAttrs (
      _: v: builtins.hasAttr "proxied" v && v.proxied
    )
    hostConfig.modules.services;

  virtualHosts =
    lib.attrsets.mapAttrs' (name: value: {
      name = value.externalAddr;
      value = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://${value.internalAddr}";
          proxyWebsockets = true; # needed if you need to use WebSocket
        };
      };
    })
    proxiedServicesSet;
in {
  networking.firewall.allowedTCPPorts = [80 443];

  security.acme = {
    defaults.email = "vagahbond@pm.me";
    acceptTerms = true;
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    inherit virtualHosts;
  };
}
