{config, ...}: {
  services.nginx.virtualHosts = {
    "mario-crade.touches-grasses.fr" = {
      forceSSL = true;
      enableACME = true;
      basicAuthFile = config.age.secrets.mkResetPassword.path;
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.mkReset.frontend.port}";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };

    "back.mario-crade.touches-grasses.fr" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.mkReset.backend.port}";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };
    };
  };

  age.secrets = {
    mkResetEnv = {
      file = ../../secrets/mk_reset_env.age;
      mode = "440";
      owner = "mk_reset";
      group = "mk_reset";
    };

    mkResetPassword = {
      file = ../../secrets/mk_reset_pwd.age;
      mode = "440";
      owner = "nginx";
      group = "nginx";
    };
  };

  services.mkReset = {
    enable = true;

    envFile = config.age.secrets.mkResetEnv.path;
  };
}
