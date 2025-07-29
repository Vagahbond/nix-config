{
  storageLocation,
  inputs,
  config,
  pkgs,
  ...
}: let
  nginx-config = pkgs.writeText "wger-nginx-config.conf" ''
    upstream wger {
        server wger:8000;
    }

    server {

        listen 80;

        location / {
            proxy_pass http://wger;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;
            proxy_set_header X-Forwarded-Host $host:$server_port;
            proxy_redirect off;
        }

        location /static/ {
            alias /home/wger/static/;
        }

        location /media/ {
            alias /home/wger/media/;
        }

        # Increase max body size to allow for video uploads
        client_max_body_size 100M;
    }
  '';
in {
  ###################################################################
  # SECRETS                                                         #
  ###################################################################
  age.secrets.wgerEnv = {
    file = ../../secrets/wger_env.age;
    mode = "440";
    owner = "root";
    group = "root";
  };

  ###################################################################
  # SERVICE                                                         #
  ###################################################################
  virtualisation.oci-containers.containers = {
    wger = {
      autoStart = true;
      image = "wger/server:latest";

      environmentFiles = [
        config.age.secrets.wgerEnv.path
      ];

      volumes = [
        "wger-static:/home/wger/static"
        "wger-media:/home/wger/media"
      ];
      hostname = "wger";
      # ports = ["8088:8000"];
      dependsOn = ["wger-database" "wger-cache"];
    };
    wger-proxy = {
      autoStart = true;
      image = "nginx:stable";

      volumes = [
        "wger-static:/home/wger/static"
        "wger-media:/home/wger/media"
        "${nginx-config}:/etc/nginx/conf.d/default.conf"
      ];
      hostname = "wger-proxy";
      ports = ["8088:80"];
      dependsOn = ["wger"];
    };
    wger-worker = {
      cmd = ["/start-worker"];
      autoStart = true;
      image = "wger/server:latest";

      environmentFiles = [
        config.age.secrets.wgerEnv.path
      ];

      volumes = [
        "wger-media:/home/wger/media"
      ];

      hostname = "wger_worker";
      dependsOn = ["wger-database" "wger-cache"];
    };
    wger-database = {
      autoStart = true;
      image = "pgvector/pgvector:pg16";
      volumes = [
        "wger-db:/var/lib/postgresql/data"
      ];
      environmentFiles = [
        config.age.secrets.wgerEnv.path
      ];
      hostname = "wger_database";
    };
    wger-cache = {
      autoStart = true;
      image = "redis:latest";
      hostname = "wger_redis";
    };
  };

  ###################################################################
  # PROXY                                                           #
  ###################################################################
  services.nginx.virtualHosts."fit.vagahbond.com" = {
    forceSSL = true;
    enableACME = true;
    # basicAuthFile = config.age.secrets.silverbulletEnv.path;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8088";
      proxyWebsockets = true; # needed if you need to use WebSocket
    };
  };
}
