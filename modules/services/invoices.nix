[
  {
    targets = [ "nixosConfiguration" ];
    conf =
      { config, ... }:
      {

        services = {
          nginx.virtualHosts = {
            "invoices.vagahbond.com" = {
              forceSSL = true;
              enableACME = true;
            };
            "accounting.vagahbond.com" = {
              forceSSL = true;
              enableACME = true;
            };
          };

          dolibarr = {
            enable = true;
            domain = "accounting.vagahbond.com";
            database = {
              type = "postgresql";
              createLocally = true;
            };
            nginx = { };
          };
        };
      };
  }
]
