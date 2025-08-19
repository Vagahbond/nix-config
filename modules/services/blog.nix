{
  config,
  pkgs,
  inputs,
  storageLocation,
  ...
}: let
  blog = pkgs.stdenv.mkDerivation {
    name = "blog";
    src = inputs.blog-contents;
    #        cp -r ${hugo-terminal}/* "themes/terminal"

    configurePhase = ''
      mkdir -p "themes"
      cp -r ${inputs.blog-theme} "themes/archie"
    '';

    buildPhase = ''
      ${pkgs.hugo}/bin/hugo --minify
    '';
    installPhase = "cp -r public $out";
  };
in {
  environment = {
    persistence.${storageLocation} = {
      directories = [
        "/var/lib/goatcounter"
      ];
    };
  };

  ###################################################
  # BLOG                                            #
  ###################################################

  services.nginx.virtualHosts = {
    "touches-grasses.fr" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        root = blog;
      };
    };
    "analytics.touches-grasses.fr" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8087";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
  };

  age.secrets.ghostEnv = {
    file = ../../secrets/ghost_env.age;
    mode = "440";
  };

  ###################################################
  # Analytics                                       #
  ###################################################
  services.goatcounter = {
    enable = true;
    proxy = true;
    port = 8087;
  };

  ###################################################
  # Joan's GHOST                                    #
  ###################################################

  services.nginx.virtualHosts."joansareno.com" = {
    # forceSSL = true;
    # enableACME = true;
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
        "joan_ghost_content:/var/lib/ghost/content"
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
