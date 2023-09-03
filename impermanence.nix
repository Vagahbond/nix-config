{
  inputs,
  config,
  lib,
  ...
}:
with lib; let
  username = import ./username.nix;

  inherit (config.modules.impermanence) storageLocation;
in {
  options.modules.impermanence = {
    storageLocation = mkOption {
      type = types.str;
      description = "Name of the path to persistent storage.";
      default = "/persistent";
      example = "/path/to/storage";
    };
  };

  imports = [
    inputs.impermanence.nixosModule
  ];

  config = {
    environment.persistence.${storageLocation} = {
      directories = [
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
      ];

      users.${username} = {
        directories = [
          "Projects"
          "Downloads"
          "Music"
          "Pictures"
          "Documents"
          "Videos"
          {
            directory = ".gnupg";
            mode = "0700";
          }
          {
            directory = ".ssh";
            mode = "0700";
          }
          {
            directory = ".local/share/keyrings";
            mode = "0700";
          }
          ".local/share"
          ".pki"
        ];

        files = [
          ".gitconfig"
        ];
      };
    };
  };
}
