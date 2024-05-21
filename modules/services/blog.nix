{
  storageLocation,
  config,
}: {
  ###################################################
  # WriteFreely                                     #
  ###################################################
  /*
  environment.persistence.${storageLocation} = {
    directories = [
      {
        directory = "/var/lib/writefreely";
        user = "writefreely";
        group = "writefreely";
        mode = "u=rwx,g=rx,o=";
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [7090];

  services.writefreely = {
    # Create a WriteFreely instance.
    enable = true;

    # Create a WriteFreely admin account.
    admin = {
      name = "root";
    };

    settings = {
      app = {
        site_name = "Vagahbond tech blog";
        federation = true;
        site_description = "Le blog des maigres";
        min_username_len = 3;
        private = false;
        local_timeline = true;
        wf_modesty = true;
        landing = "/read";
        open_registration = false;
        user_invites = "admin";
      };
    };

    nginx = {
      # Enable Nginx and configure it to serve WriteFreely.
      enable = true;

      # You can force users to connect with HTTPS.
      forceSSL = true;
    };
    acme = {
      # Automatically fetch and configure SSL certs.
      enable = true;
    };

    # The public host name to serve.
    host = "joan.serano.vagahbond.com";
  };
  */
  ###################################################
  # GHOST                                           #
  ###################################################

  services.nginx.virtualHosts."blog.vagahbond.com" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8080";
      proxyWebsockets = true; # needed if you need to use WebSocket
    };
  };

  age.secrets.ghostEnv = {
    file = ../../secrets/ghost_env.age;
    mode = "440";
    #     owner = "docker";
    #     group = "docker";
  };

  virtualisation.oci-containers.containers = {
    ghost = {
      autoStart = true;
      image = "docker.io/library/ghost:5-alpine";
      dependsOn = ["ghostDb"];
      environmentFiles = [
        config.age.secrets.ghostEnv.path
      ];
      volumes = [
        "ghost_content:/var/lib/ghost/content"
      ];
      hostname = "ghost";
      ports = ["8080:2368"];
    };
    ghostDb = {
      autoStart = true;
      image = "docker.io/library/mysql:8";
      volumes = [
        "ghost_db:/var/lib/mysql"
      ];
      environmentFiles = [
        config.age.secrets.ghostEnv.path
      ];
      hostname = "ghost_db";
    };
  };

  ###################################################
  # Joan's GHOST                                    #
  ###################################################

  services.nginx.virtualHosts."joansareno.com" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8081";
      proxyWebsockets = true; # needed if you need to use WebSocket
    };
    serverAliases = [
      "www.joansareno.com"
    ];
  };

  age.secrets.joanGhostEnv = {
    file = ../../secrets/joan_ghost_env.age;
    mode = "440";
    #     owner = "docker";
    #     group = "docker";
  };

  virtualisation.oci-containers.containers = {
    joanGhost = {
      autoStart = true;
      image = "docker.io/library/ghost:5-alpine";
      dependsOn = ["joanGhostDb"];
      environmentFiles = [
        config.age.secrets.joanGhostEnv.path
      ];
      volumes = [
        "ghost_content:/var/lib/ghost/content"
      ];
      hostname = "joan_ghost";
      ports = ["8081:2368"];
    };
    joanGhostDb = {
      autoStart = true;
      image = "docker.io/library/mysql:8";
      volumes = [
        "joan_ghost_db:/var/lib/mysql"
      ];
      environmentFiles = [
        config.age.secrets.joanGhostEnv.path
      ];
      hostname = "joan_ghost_db";
    };
  };
}
