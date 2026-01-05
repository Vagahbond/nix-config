{
  config,
  self,
  pkgs,
  ...
}:
let
  username = import ../../username.nix;
  inherit (config.modules.impermanence) storageLocation;

  keys = import ../../secrets/sshKeys.nix {
    inherit config;
    inherit (pkgs) lib;
  };

  upgradeScript = pkgs.writeScriptBin "upgrade" ''nh os switch --refresh -R --no-update-lock-file github:vagahbond/nix-config  '';

in
{
  imports = [
    ./options.nix
  ];

  environment.systemPackages = [ upgradeScript ];

  users = {
    mutableUsers = false;
    users = {
      root = {
      };

      ${username} = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "sudo"
        ];
        home = "/home/${username}";
        description = "Main user";
        hashedPassword = config.modules.user.password;
      };

      upgrader = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "sudo"
        ];
        home = "/home/upgrader";
        description = "A user made to update stuff";
        openssh.authorizedKeys.keys = with keys; [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDr8QDLbHVJFcCYfbJW0sbACpX6RWrFig/nHfUbXNbx1 yoniserv"
          platypute_access.pub
        ];

      };

    };
  };

  nix.settings.trusted-users = [ "upgrader" ];

  security.sudo = {
    enable = true;
    extraRules = [
      {
        # allow wheel group to run nixos-rebuild without password
        # this s a less vulnerable alternative to having wheelNeedsPassword = false
        users = [
          "upgrader"
        ];
        commands = [
          {
            command = "${upgradeScript}/bin/upgrade";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/upgrade";
            options = [ "NOPASSWD" ];
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
