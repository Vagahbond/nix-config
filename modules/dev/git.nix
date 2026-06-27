[
  {
    targets = [
      "nixosConfiguration"
      "darwinConfiguration"
    ];
    conf =
      { pkgs, config, ... }:
      {
        age.secrets.gitKey = {
          file = ../../secrets/github_access.age;
          owner = "vagahbond";
          group = "users";
        };

        home-files.vagahbond = {
          ".ssh/github_access.pub".text =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBi/qH3wsZVyF61Wd1qgwvzx5VRl4uPYEWNxSCbYLC+n vagahbond@framework";
          ".ssh/github_access".source = config.age.secrets.gitKey.path;
        };
        environment = {
          systemPackages = with pkgs; [
            lazygit
            gh
            git
          ];
        };
      };
  }

  {
    targets = [
      "darwinConfiguration"
      "nixosConfiguration"
    ];
    conf =
      { username, ... }:
      {
        home-files.${username}.".gitconfig".text = ''
          [user]
           name = Vagahbond
           email = vagahbond@pm.me        
          [init]
            defaultbranch = master
        '';
      };
  }
  /*
    {
      targets = [
        "nixosConfiguration"
      ];
      conf =
        {
          username,
          config,
          ...
        }:
        {
          environment.persistence.${config.persistence.storageLocation} = {
            users.${username} = {
              directories = [
                ".config/lazygit"
                ".config/gh"
              ];
            };
          };

          programs = {
            git = {
              enable = true;
              config = {
                user = {
                  name = "Vagahbond";
                  email = "vagahbond@pm.me";
                };
                init = {
                  defaultBranch = "master";
                };
                url = {
                  "https://github.com/" = {
                    insteadOf = [
                      "gh:"
                      "github:"
                    ];
                    "https://git.vagahbond.com/" = {
                      insteadOf = [
                        "vag:"
                        "fj:"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
    }
  */
]
