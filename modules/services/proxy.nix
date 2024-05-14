_: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "vagahbond@pm.me";
  };

  services.nginx = {
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };
  networking.firewall.allowedTCPPorts = [443 80];
}
