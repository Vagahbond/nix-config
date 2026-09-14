[

  {
    targets = [
      "nixosConfiguration"
      "darwinConfiguration"
    ];
    conf =
      {
        pkgs,
        username,
        config,
        ...
      }:
      {
        home-files.${username} = {
          ".ssh/config" = {
            source = config.age.secrets.sshConfig.path;
          };
        };

        age.secrets = {
          sshConfig = {
            file = ../../secrets/ssh_config.age;
            owner = username;
            mode = "400";
          };
        };

        environment.systemPackages = with pkgs; [
          sshs
        ];

        programs.ssh.knownHosts = {
          nixbuild = {
            hostNames = [ "eu.nixbuild.net" ];
            publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
          };

          "vagahbond.com".publicKey =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDSsrITB9huHd7yjLsU5HaI9qVqKe9o1upg6U5uJVB2X";

          "github.com".publicKey =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";

          "linux-builder".publicKey =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJBWcxb/Blaqt1auOtE+F8QUWrUotiC5qBJ+UuEWdVCb";

          "git.vagahbond.com".publicKey =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDSsrITB9huHd7yjLsU5HaI9qVqKe9o1upg6U5uJVB2X";
        };
      };
  }
]
