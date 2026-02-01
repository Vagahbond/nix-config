# TODO: Uncontainerize
{
  targets = [
    "platypute"
  ];

  nixosConfiguration = _: {
    ###################################################
    # Stirling-pdf                                    #
    ###################################################

    services.nginx.virtualHosts."pdf.vagahbond.com" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8085";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };

    # age.secrets.s-pdfEnv = {
    #   file = ../../secrets/ghost_env.age;
    #   mode = "440";
    # };

    virtualisation.oci-containers.containers = {
      sPdf = {
        autoStart = true;
        image = "docker.io/frooodle/s-pdf:latest";
        # environmentFiles = [
        #   config.age.secrets.ghostEnv.path
        # ];
        volumes = [
          "stirlingTainingData:/usr/share/tessdata #Required for extra OCR languages"
          "stirlingExtraConfigs:/configs"
          #       "./customFiles:/customFiles/"
          #       "./logs:/logs/"
        ];
        environment = {
          DOCKER_ENABLE_SECURITY = "false";
          INSTALL_BOOK_AND_ADVANCED_HTML_OPS = "false";
          LANGS = "en_GB";
        };
        hostname = "spdf";
        ports = ["8085:8080"];
      };
    };
  };
}
