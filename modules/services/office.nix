{
  targets = [
    "platypute"
  ];

  nixosConfiguration = {
    pkgs,
    config,
    ...
  }: {
    environment.persistence.${config.persistence.storageLocation} = {
      directories = [
        "/var/lib/cool"
      ];
    };

    services.nginx.virtualHosts."office.vagahbond.com" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://[::1]:${toString config.services.collabora-online.port}";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };

    services.collabora-online = {
      enable = true;
      port = 9980;
      settings = {
        # Rely on reverse proxy for SSL
        ssl = {
          enable = false;
          termination = true;
        };

        # Listen on loopback interface only, and accept requests from ::1
        net = {
          listen = "loopback";
          post_allow.host = ["::1"];
        };

        # Restrict loading documents from WOPI Host nextcloud.example.com
        storage.wopi = {
          "@allow" = true;
          host = [config.services.nextcloud.hostName];
        };

        # Set FQDN of server
        server_name = "office.vagahbond.com";
      };
    };

    ###################################################################
    # COLLABORA                                                    #
    ###################################################################

    networking.hosts = {
      "127.0.0.1" = [
        "nuage.vagahbond.com"
        "office.vagahbond.com"
      ];
      "::1" = [
        "nuage.vagahbond.com"
        "office.vagahbond.com"
      ];
    };

    systemd.services.nextcloud-config-collabora = let
      inherit (config.services.nextcloud) occ;

      wopi_url = "http://[::1]:${toString config.services.collabora-online.port}";
      public_wopi_url = "https://office.vagahbond.com";
      wopi_allowlist = pkgs.lib.concatStringsSep "," [
        "127.0.0.1"
        "::1"
      ];
    in {
      wantedBy = ["multi-user.target"];
      after = [
        "nextcloud-setup.service"
        "coolwsd.service"
      ];
      requires = ["coolwsd.service"];
      script = ''
        ${occ}/bin/nextcloud-occ config:app:set richdocuments wopi_url --value ${pkgs.lib.escapeShellArg wopi_url}
        ${occ}/bin/nextcloud-occ config:app:set richdocuments public_wopi_url --value ${pkgs.lib.escapeShellArg public_wopi_url}
        ${occ}/bin/nextcloud-occ config:app:set richdocuments wopi_allowlist --value ${pkgs.lib.escapeShellArg wopi_allowlist}
        ${occ}/bin/nextcloud-occ richdocuments:setup
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };
  };
}
