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
        lib,
        ...
      }:
      let
        recipients = import ../../secrets/recipients.nix;
        secretRules = import ../../secrets/secrets.nix;
        secretNames = [
          "builder_2_access"
          "builder_access"
          "dedistonks_access"
          "github_access"
          "platypute_access"
        ];
        hostRecipient = recipients.${config.networking.hostName} or null;
        hasSecret =
          name: hostRecipient != null && lib.elem hostRecipient secretRules."${name}.age".publicKeys;
        identityFile =
          name: lib.optionalString (hasSecret name) "IdentityFile ${config.age.secrets.${name}.path}";
      in
      {
        age.secrets = lib.genAttrs (builtins.filter hasSecret secretNames) (name: {
          file = ../../secrets + "/${name}.age";
          owner = username;
          mode = "400";
        });

        environment.systemPackages = with pkgs; [
          sshs
        ];

        programs.ssh = {
          extraConfig = ''
            Host *
              AddKeysToAgent yes
              IdentityFile ~/.ssh/id_ed25519

            Host "Kube"
              HostName vagahbond.com
              User guardian
              Port 31

            Host dedistonks
              HostName vagahbond.com
              User vagahbond
              Port 45
              ${identityFile "dedistonks_access"}

            Host github.com
              HostName github.com
              PreferredAuthentications publickey
              ${identityFile "github_access"}

            Host VagahGit
              HostName git.vagahbond.com
              PreferredAuthentications publickey  
              ${identityFile "github_access"}

            Host platypute
              HostName vagahbond.com  
              User vagahbond
              Port 22
              ${identityFile "platypute_access"}

            Host builder
              HostName vagahbond.com
              User builder
              port 22
              ${identityFile "builder_access"}

            Host nixbuild
              HostName eu.nixbuild.net
              PubkeyAcceptedKeyTypes ssh-ed25519
              ServerAliveInterval 60
              ${identityFile "builder_2_access"}
          '';

          knownHosts = {
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
      };
  }
]
