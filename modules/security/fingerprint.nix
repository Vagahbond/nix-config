{
  targets = [
    "air"
    "framework"
  ];

  nixosConfiguration =
    { config, ... }:
    {
      services = {
        fprintd = {
          enable = true;
        };
      };

      # keep fingerprints
      environment = {
        persistence.${config.impermanence.storageLocation} = {
          directories = [
            "/var/lib/fprint"
          ];
        };
      };
    };

  darwinConfiguration = _: {
    security.pam.services.sudo_local.touchIdAuth = true;
  };

}
