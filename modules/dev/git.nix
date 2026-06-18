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
            lazygit
            gh
            git
          ];
        };
      };
  }

  {
    targets = [ "darwinConfiguration" ];
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
  }
]
