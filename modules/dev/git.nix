{
  targets = [
    "air"
    "platypute"
    "framework"
  ];

  sharedConfiguration =
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

  darwinConfiguration =
    { username, ... }:
    {
      hjem = {
        users.${username}.files.".gitconfig" = {
          clobber = true;
          text = ''
            [user]
             name = Vagahbond
             email = vagahbond@pm.me        
            [init]
              defaultbranch = master
          '';
        };
      };
    };

  nixosConfiguration =
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
    };

  programs = {
    git = {
      enable = true;
      config = {
        user = {
          name = "Yoni FIRROLONI";
          email = "pro@yoni-firroloni.com";
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
          };
        };
      };
    };
  };
}
