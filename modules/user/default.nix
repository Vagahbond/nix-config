{config, ...}: let
  username = import ../../username.nix;
  inherit (config.modules.impermanence) storageLocation;
in {
  imports = [
    ./options.nix
  ];

  users = {
    mutableUsers = false;
    users = {
      root = {
      };

      ${username} = {
        isNormalUser = true;
        extraGroups = ["wheel" "sudo"];
        home = "/home/${username}";
        description = "Main user";
        hashedPassword = config.modules.user.password;
      };
    };
  };

  security.sudo = {
    enable = true;
    extraRules = [
      {
        # allow wheel group to run nixos-rebuild without password
        # this is a less vulnerable alternative to having wheelNeedsPassword = false
        groups = ["sudo" "wheel"];
        commands = [
          {
            command = "/nix/store/*/bin/switch-to-configuration";
            options = ["NOPASSWD"];
          }
          {
            command = "/run/current-system/bin/switch-to-configuration";
            options = ["NOPASSWD"];
          }
          {
            command = "/run/current-system/sw/bin/nix-collect-garbage";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };

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
}
