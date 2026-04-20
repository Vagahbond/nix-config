{
  targets = [
    "platypute"
  ];

  nixosConfiguration =
    {
      pkgs,
      config,
      ...
    }:
    {

      ###################################################
      # Analytics                                       #
      ###################################################

      services.nginx.virtualHosts = {
        "analytics.vagahbond.com" = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:${toString config.services.goatcounter.port}";
              proxyWebsockets = true; # needed if you need to use WebSocket
            };
          };
        };
      };

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
