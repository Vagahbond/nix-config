{
  targets = [
    "air"
    "platypute"
    "framework"
  ];

  sharedConfiguration =
    { pkgs, ... }:

    (mkIf cfg.docker.enable {
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

      # Docker
      /*
      virtualisation.docker.enable = true;
      virtualisation.docker.rootless = {
        enable = true;
        setSocketVariable = true;
      };

      users.users.${username}.extraGroups = ["docker"];

      */
      # keep docker data
      environment.persistence.${impermanence.storageLocation} = {
        directories = [
          "/var/lib/docker"
          "/var/lib/containers"
        ];

        users.${username} = {
          directories = [
            ".docker"
            ".local/share/docker"
            ".local/share/containers"
          ];
        };
      };
    })
