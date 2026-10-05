[
  {
    targets = [ "nixosConfiguration" ];
    conf =
      {
        pkgs,
        inputs,
        config,
        ...
      }:
      {
        imports = [ inputs.impermanence.nixosModules.default ];

        options.persistence = {
          enable = pkgs.lib.mkEnableOption "impermanence";

          storageLocation = pkgs.lib.mkOption {
            type = pkgs.lib.types.str;
            description = "Name of the path to persistent storage.";
            default = "/nix/persistent";
            example = "/path/to/storage";
          };
        };

        config = {

          environment.persistence.${config.persistence.storageLocation} = {
            enable = config.persistence.enable;
            directories = [
              "/var/cache"
              "/var/log"
              "/var/lib"
              "/var/tmp"
            ];
            files = [
              "/etc/machine-id"
            ];
          };
        };
      };
  }
]
