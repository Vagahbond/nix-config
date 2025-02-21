{inputs, ...}: let
in {
  services.nginx = {
    enable = true;
    virtualHosts."learnify.vagahbond.com" = {
      enableACME = true;
      forceSSL = true;
      root = inputs.learnify;
    };
  };
}
