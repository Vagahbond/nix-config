{config, ...}: {
  age.secrets.invoiceshelfEnv = {
    file = ../../secrets/invoiceshelf_env.age;
    mode = "440";
  };

  virtualisation.oci-containers.containers = {
    invoiceshelf = {
      autoStart = true;
      image = "docker.io/invoiceshelf/invoiceshelf";
      volumes = [
        "invoiceshelf:/conf"
        "invoiceshelf:/data"
      ];
      environment = {
        # PHP timezone e.g. PHP_TZ=America/New_York
        PHP_TZ = "Australia/Brisbane";
        TIMEZONE = "Australia/Brisbane";
        APP_NAME = "Laravel";
        APP_ENV = "local";
        APP_URL = "invoices.vagahbond.com";
        DB_CONNECTION = "mysql";
        DB_HOST = "invoiceshelf_db";
        DB_PORT = "3306";
        DB_DATABASE = "invoiceshelf";
        SESSION_LIFETIME = "120";
        SESSION_DOMAIN = "invoices.vagahbond.com";
      };
      environmentFiles = [
        config.age.secrets.invoiceshelfEnv.path
      ];
      dependsOn = ["invoiceshelfDb"];
      hostname = "invoiceshelf";
      ports = ["8069:80"];
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
