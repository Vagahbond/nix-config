{
  targets = [
    "platypute"
    "framework"
  ];

  nixosConfiguration =
    {
      pkgs,
      inputs,
      config,
      ...
    }:
    {
      imports = [ inputs.impermanence.nixosModules.default ];

      options.persistence = {
        storageLocation = pkgs.lib.mkOption {
          type = pkgs.lib.types.str;
          description = "Name of the path to persistent storage.";
          default = "/nix/persistent";
          example = "/path/to/storage";
        };
      };

      config = {
        environment.persistence.${config.persistence.storageLocation} = {
          directories = [
            "/var/cache"
            "/var/log"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
          ];
          files = [
            #  "/etc/machine-id"
          ];
        };
      };
    };
}
