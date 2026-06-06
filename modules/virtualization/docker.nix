[
  {
    targets = [
      "nixosConfiguration"
      "darwinConfiguration"
    ];
    conf =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          docker-compose
          lazydocker
        ];

        virtualisation.podman = {
          enable = true;

          # Create a `docker` alias for podman, to use it as a drop-in replacement
          dockerCompat = true;

          # Required for containers under podman-compose to be able to talk to each other.
          defaultNetwork.settings.dns_enabled = true;
        };
      };
  }
  {
    targets = [ "nixosConfiguration" ];
    conf =
      {
        username,
        config,
        ...
      }:
      {
        # keep docker data
        environment.persistence.${config.persistence.storageLocation} = {
          # directories = [
          #   "/var/lib/docker"
          #   "/var/lib/containers"
          # ];

          users.${username} = {
            directories = [
              ".docker"
              ".local/share/docker"
              ".local/share/containers"
            ];
          };
        };
      };
  }
]
