{storageLocation}: {
  environment.persistence.${storageLocation} = {
    directories = [
      {
        directory = "/var/lib/writefreely";
        user = "writefreely";
        group = "writefreely";
        mode = "u=rwx,g=rx,o=";
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [7090];

  services.writefreely = {
    # Create a WriteFreely instance.
    enable = true;

    # Create a WriteFreely admin account.
    admin = {
      name = "root";
    };

    settings = {
      app = {
        site_name = "Vagahbond tech blog";
        federation = true;
        site_description = "Le blog des maigres";
        min_username_len = 3;
        private = false;
        local_timeline = true;
        wf_modesty = true;
        landing = "/read";
        open_registration = false;
        user_invites = "admin";
      };
    };

    nginx = {
      # Enable Nginx and configure it to serve WriteFreely.
      enable = true;

      # You can force users to connect with HTTPS.
      forceSSL = true;
    };
    acme = {
      # Automatically fetch and configure SSL certs.
      enable = true;
    };

    # The public host name to serve.
    host = "blog.vagahbond.com";
  };
}
