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

      # environment = {
      #   persistence.${config.persistence.storageLocation} = {
      #     directories = [
      #       {
      #         directory = "/var/lib/goatcounter";
      #         user = "goatcounter";
      #         group = "goatcounter";
      #         mode = "u=rwx,g=rx,o=";
      #       }
      #     ];
      #   };
      # };

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

          grassTickIntervalSeconds = 60;
          secure = true;
        };

      };

    };
}
