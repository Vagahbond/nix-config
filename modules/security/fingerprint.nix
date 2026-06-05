[
  {
    targets = [ "nixosConfiguration" ];
    conf =
      { config, ... }:
      {
        services = {
          fprintd = {
            enable = true;
          };
        };

        # keep fingerprints
        # environment = {
        #   persistence.${config.impermanence.storageLocation} = {
        #     directories = [
        #       "/var/lib/fprint"
        #     ];
        #   };
        # };
      };
  }
  {
    targets = [ "darwinConfiguration" ];
    conf = _: {
      security.pam.services.sudo_local.touchIdAuth = true;
    };
  }
]
