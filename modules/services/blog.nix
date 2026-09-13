[
  {
    targets = [ "nixosConfiguration" ];
    conf =
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

        ###################################################
        # BLOG                                            #
        ###################################################

        networking.firewall.allowedTCPPorts = [ 3012 ];

        services.touchesGrasses = {
          enable = true;
          address = "touches-grasses.fr";

          enableNginx = true;

          grassServer = {
            enable = true;

            host = "grass.touches-grasses.fr";
            port = 3012;

            # Tick grass 4 times daily
            grassTickIntervalSeconds = 60 * 60 * 6;
            secure = true;
          };

        };

      };
  }
]
