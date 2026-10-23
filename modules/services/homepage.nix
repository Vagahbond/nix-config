[
  {
    targets = [ "nixosConfiguration" ];
    conf =
      { inputs, pkgs, ... }:
      let
        domain = "yoni-firroloni.com";
      in
      {

        services.nginx = {

          virtualHosts.${domain} = {
            default = true;
            enableACME = true;
            forceSSL = true;
            root = inputs.website.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
              siteOrigin = "https://${domain}";
            };
            serverAliases = [
              "vagahbond.com"
            ];
          };
        };
      };
  }
]
