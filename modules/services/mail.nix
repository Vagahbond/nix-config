{
  inputs,
  config,
  storageLocation,
  ...
}: {
  age.secrets.mailUserPass = {
    file = ../../secrets/mail_user_password.age;
    mode = "440";
    owner = "virtualMail";
    group = "virtualMail";
  };

  environment.persistence.${storageLocation} = {
    # TODO: independent redis and rabbitmq with special volume
    directories = [
      {
        directory = "/var/dkim";
        user = "rspamd";
        group = "rspamd";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/var/sieve";
        user = "dovecot2";
        group = "dovecot2";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/var/vmail";
        user = "virtualMail";
        group = "virtualMail";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/var/lib/dkim";
        user = "rspamd";
        group = "rspamd";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/var/lib/rspamd";
        user = "rspamd";
        group = "rspamd";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/var/lib/redis-rspamd";
        user = "redis-rspamd";
        group = "redis-rspamd";
        mode = "u=rwx,g=rx,o=";
      }
      {
        directory = "/var/lib/postfix";
        user = "postfix";
        group = "postfix";
        mode = "u=rwx,g=rx,o=";
      }
    ];
  };

  mailserver = {
    enable = true;
    stateVersion = 3;
    fqdn = "mail.vagahbond.com";
    domains = ["vagahbond.com"];

    # dmarcReporting.enable = true;

    enableImap = false;
    enableSubmission = false;

    enableImapSsl = true;
    enableSubmissionSsl = true;

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "no-reply@vagahbond.com" = {
        hashedPasswordFile = config.age.secrets.mailUserPass.path;
        # sendOnly = true;
        name = "no-reply@vagahbond.com";
        aliases = ["no-reply@vagahbond.com"];
      };
      "me@vagahbond.com" = {
        hashedPasswordFile = config.age.secrets.mailUserPass.path;
        # sendOnly = true;
        name = "me@vagahbond.com";
        aliases = ["@vagahbond.com"];
      };
    };

    certificateScheme = "acme-nginx";
  };
  # services.postfix.networks = ["localhost"];
  networking.firewall.allowedTCPPorts = [25 143 993 465];
}
