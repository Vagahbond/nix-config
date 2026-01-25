{
  targets = [
    "platypute"
    "framework"
    "air"
  ];

  sharedConfiguration =
    { username, config, ... }:
    {
      home-manager.users.${username} = {
        nixpkgs.config = {
          allowUnfree = true;
        };

        home = {
          inherit username;
          homeDirectory = config.users.users.${username}.home;
          stateVersion = "22.11";
        };
      };
    };

  nixosConfiguration =
    { inputs, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.default ];
    };

  darwinConfiguration =
    { inputs, ... }:
    {
      imports = [ inputs.home-manager.darwinModules.default ];
    };
}
