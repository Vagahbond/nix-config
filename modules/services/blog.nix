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
    {

      imports = [
        inputs.blog.nixosModules.default
      ];

      environment = {
        persistence.${config.persistence.storageLocation} = {
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

      networking.firewall.allowedTCPPorts = [ 3012 ];

      services.touches-grasses = {
        enable = true;
        address = "touches-grasses.fr";

        enableNginx = true;

        grassServer = {
          enable = true;

          host = "grass.touches-grasses.fr";
          port = 3012;

          grassTickIntervalSeconds = 60;
          secure = false;
        };

      };
      # services.nginx.virtualHosts = {
      #   "touches-grasses.fr" = {
      #     forceSSL = true;
      #     enableACME = true;
      #     locations."/" = {
      #       root = inputs.blog.packages.${pkgs.stdenv.system}.default;
      #     };
      #   };
      #   "analytics.touches-grasses.fr" = {
      #     forceSSL = true;
      #     enableACME = true;
      #     locations."/" = {
      #       proxyPass = "http://127.0.0.1:8084";
      #       proxyWebsockets = true; # needed if you need to use WebSocket
      #     };
      #   };
      # };
      #
      # age.secrets.ghostEnv = {
      #   file = ../../secrets/ghost_env.age;
      #   mode = "440";
      # };

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
