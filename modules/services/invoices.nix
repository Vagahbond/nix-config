{
  storageLocation,
  config,
}: {
  environment.persistence.${storageLocation} = {
    # TODO: independent redis and rabbitmq with special volume
    directories = [
      {
        directory = "/var/lib/crater";
        user = "invoiceplane";
        group = "invoiceplane";
        mode = "u=rwx,g=rx,o=";
      }
    ];
  };

  age.secrets.invoiceshelfEnv = {
    file = ../../secrets/invoiceshelf_env.age;
    mode = "440";
  };

  virtualisation.oci-containers.containers = {
    invoiceshelf = {
      autoStart = true;
      image = "docker.io/library/invoiceshelf/invoiceshelf";
      dependsOn = ["invoiceshelfDb"];
      hostname = "invoice";
      ports = ["8069:3306"];
    };

    invoiceshelfDb = {
      autoStart = true;
      image = "docker.io/library/mysql:8";
      environmentFiles = [
        config.age.secrets.invoiceshelfEnv.path
      ];
      volumes = [
        "invoiceshelf_db:/var/lib/mysql"
      ];
      hostname = "invoiceshelf_db";
    };
  };

  services.nginx.virtualHosts."invoices.vagahbond.com" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8069";
      proxyWebsockets = true; # needed if you need to use WebSocket
    };
  };
}
