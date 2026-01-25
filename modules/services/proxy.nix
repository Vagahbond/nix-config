{
  targets = [
    "platypute"
  ];

  nixosConfiguration = _: {
    security.acme = {
      acceptTerms = true;
      defaults.email = "vagahbond@pm.me";
    };

    services.nginx = {
      statusPage = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      commonHttpConfig = ''
        vhost_traffic_status_zone;
        vhost_traffic_status_filter_by_set_key $host zone=vhost;
      '';

      virtualHosts.localhost = {
        locations = {
          "/metrics" = {
            extraConfig = ''
              vhost_traffic_status_display;
              vhost_traffic_status_display_format prometheus;
            '';
          };
        };
      };
    };
    networking.firewall.allowedTCPPorts = [
      443
      80
    ];
  };
}
