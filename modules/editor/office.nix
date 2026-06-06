[
  {
    targets = [
      "nixosConfiguration"
      "darwinConfiguration"
    ];
    conf =
      { pkgs, ... }:
      {
        environment = {
          systemPackages = with pkgs; [
            libreoffice
          ];
        };
      };
  }
  {
    targets = [ "nixosConfiguration" ];
    conf =
      {
        config,
        username,
        ...
      }:
      {
        environment.persistence.${config.impermanence.storageLocation} = {
          users.users.${username} = {
            directories = [
              ".config/libreoffice"
            ];
            files = [
            ];
          };
        };
      };
  }
]
