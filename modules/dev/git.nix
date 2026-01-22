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
        ];
      };
    };

  nixosConfiguration =
    { username, inputs, ... }:
    {
      environment.persistence.${inputs.impermanence.storageLocation} = {
        users.${username} = {
          directories = [
            ".config/lazygit"
            ".config/gh"
          ];
        };
      };
    };

  # dependent on homemanager ?
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
