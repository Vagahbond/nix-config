{config, ...}: {
  age.secrets.invoiceshelfEnv = {
    file = ../../secrets/invoiceshelf_env.age;
    mode = "440";
  };

  services = {
    nginx.virtualHosts = {
      "invoices.vagahbond.com" = {
        forceSSL = true;
        enableACME = true;
      };
    };

    kimai.sites."invoices.vagahbond.com" = {
    };
  };
}
