{storageLocation}: {
  ###################################################
  # PORTS                                           #
  ###################################################
  networking.firewall.allowedTCPPorts = [7060 3812];

  ###################################################
  # IMPERMANENCE                                    #
  ###################################################
  environment.persistence.${storageLocation} = {
    directories = [
      {
        directory = "/var/lib/bitwarden_rs";
        user = "vaultwarden";
        group = "vaultwarden";
        mode = "u=rwx,g=rx,o=";
      }
    ];
  };

  ###################################################
  # SERVICES                                        #
  ###################################################

  services.vaultwarden = {
    enable = true;
    # backupDir = "/var/lib/bitwarden_rs/backup";
    # environmentFile =
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 7060;
      DOMAIN = "https://vagahbond.com";
      ROCKET_LOG = "critical";
    };
  };

  ###################################################
  # SSL                                             #
  ###################################################
  services.nginx.virtualHosts."pass.vagahbond.com" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:7060";
      proxyWebsockets = true; # needed if you need to use WebSocket
    };
  };
}
