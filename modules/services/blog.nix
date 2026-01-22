{
  targets = [
    "platypute"
  ];

  nixosConfiguration =
    {
      pkgs,
      inputs,
      config,
      ...
    }:
    let
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
    in
    {
      environment = {
        persistence.${config.impermanence.storageLocation} = {
          directories = [
            {
              directory = "/var/lib/goatcounter";
              user = "goatcounter";
              group = "goatcounter";
              mode = "u=rwx,g=rx,o=";
            }
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
            proxyPass = "http://127.0.0.1:8084";
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

      users.groups.goatcounter = { };

      users.users.goatcounter = {
        isNormalUser = true;
        group = "goatcounter";
        createHome = false;
      };

      services.goatcounter = {
        enable = true;
        proxy = true;
        port = 8084;
      };

      # Fix incompatibility issue
      systemd.services.goatcounter.serviceConfig = {
        DynamicUser = pkgs.lib.mkForce false;
        User = "goatcounter";
      };
    };
}
