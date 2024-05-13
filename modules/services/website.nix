{
  config,
  hostConfig,
  pkgs,
  lib,
  ...
}: let
  website = pkgs.fetchFromGitHub {
    owner = "vagahbond";
    repo = "website";
    rev = "master";
    sha256 = "sha256-U8JEnN4VsEnhp8W3qd9mmUaNY/Lqwyw+IIyvi9aUUwE=";
  };
in {
  networking.firewall.allowedTCPPorts = [80];

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    virtualHosts."yoni-firroloni.com" = {
      addSSL = false;
      enableACME = false;
      root = "${website}/src";
    };
  };
}
