{
  targets = [
    "air"
    "platypute"
    "framework"
  ];

  sharedConfiguration = {pkgs, ...}: {
    environment = {
      systemPackages = with pkgs; [
        lazygit
        gh
        git
      ];
    };
  };

  darwinConfiguration = {username, ...}: {
    home-manager.users.${username}.home.file.".gitconfig".text = ''
      [user]
       name = Yoni Firroloni
       email = pro@yoni-firroloni.com
      [init]
        defaultbranch = main
    '';
  };

  nixosConfiguration = {
    username,
    config,
    ...
  }: {
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
