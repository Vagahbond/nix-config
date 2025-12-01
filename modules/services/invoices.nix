{
  config,
  storageLocation,
  ...
}: {
  /*
    age.secrets.dolibarr = {
    file = ../../secrets/dolibarr.age;
    mode = "440";
  };
  */
  environment.persistence.${storageLocation} = {
    directories = [
      {
        directory = "/var/lib/dolibarr";
        user = "dolibarr";
        group = "dolibarr";
        mode = "u=rwx,g=rx,o=";
      }
    ];
  };

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
      nginx = {};
    };

    kimai.sites."invoices.vagahbond.com" = {
    };
  };
}
