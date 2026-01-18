{
  config,
  lib,
  helpers,
  ...
}:
let
  username = import ../../username.nix;
  inherit (config.modules.impermanence) storageLocation;

in
{
  imports = [
    ./options.nix
  ];

  config = lib.mkMerge [
    (lib.mkIf (!helpers.isDarwin) {
      users = {
        mutableUsers = false;
        users = {
          root = {
          };

          ${username} = {
            isNormalUser = true;
            extraGroups = [
              "wheel"
            ];
            home = "/home/${username}";
            description = "Main user";
            hashedPassword = config.modules.user.password;
          };
        };
      };

    })
    (lib.mkIf config.modules.impermanence.enable {

      environment.persistence.${storageLocation} = {
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

            ".local/share/nix"
            ".pki"
          ];

          files = [
            ".gitconfig"
          ];
        };
      };
    })
  ];
}
