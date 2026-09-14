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
        # Dead code: ssh config used to be a fully encrypted blob copied verbatim
        # into ~/.ssh/config. Replaced by the interpolated programs.ssh.extraConfig
        # below, which points IdentityFile entries straight at the agenix-decrypted
        # secret paths instead of copying keys into ~/.ssh. Kept here for reference,
        # remove once confirmed working.
        # home-files.${username} = {
        #   ".ssh/config" = {
        #     source = config.age.secrets.sshConfig.path;
        #   };
        # };
        #
        # age.secrets = {
        #   sshConfig = {
        #     file = ../../secrets/ssh_config.age;
        #     owner = username;
        #     mode = "400";
        #   };
        # };

        # Private keys used by the extraConfig IdentityFile entries below.
        # Declared here (rather than modules/admin/keys.nix) because this is
        # the module that actually consumes the decrypted paths; keys.nix used
        # to copy these into ~/.ssh and is now dead code.
        age.secrets = {
          dedistonks_access = {
            file = ../../secrets/dedistonks_access.age;
            owner = username;
            mode = "400";
          };
          github_access = {
            file = ../../secrets/github_access.age;
            owner = username;
            mode = "400";
          };
          platypute_access = {
            file = ../../secrets/platypute_access.age;
            owner = username;
            mode = "400";
          };
          builder_access = {
            file = ../../secrets/builder_access.age;
            owner = username;
            mode = "400";
          };
          builder_2_access = {
            file = ../../secrets/builder_2_access.age;
            owner = username;
            mode = "400";
          };
        };

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
              IdentityFile ${config.age.secrets.dedistonks_access.path}

            Host github.com
                HostName github.com
                PreferredAuthentications publickey
                IdentityFile ${config.age.secrets.github_access.path}

            Host VagahGit
                HostName git.vagahbond.com
                PreferredAuthentications publickey  
                IdentityFile ${config.age.secrets.github_access.path}

            Host platypute
              HostName vagahbond.com  
              User vagahbond
              Port 22
              IdentityFile ${config.age.secrets.platypute_access.path}

            Host builder
              HostName vagahbond.com
              User builder
              port 22
              IdentityFile  ${config.age.secrets.builder_access.path}

            Host nixbuild
              PubkeyAcceptedKeyTypes ssh-ed25519
              ServerAliveInterval 60
              IdentityFile ${config.age.secrets.builder_2_access.path}
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
