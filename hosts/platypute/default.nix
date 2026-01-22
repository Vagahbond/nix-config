{
  name = "platypute";
  platform = "x86_64-linux";

  configuration =
    { inputs, username, ... }:
    {
      imports = [
        ./hardware-configuration.nix
        ./disk-config.nix
        inputs.impermanence.nixosModule
        inputs.universe.nixosModules.default
        inputs.mkReset.nixosModules.default
      ];

      system.stateVersion = "22.11"; # Did you read the comment?
      home-manager.users.${username} = {

        home.stateVersion = "22.11";
      };

      config = {
        modules = {
          impermanence = {
            enable = true;
          };
          user.password = "$y$j9T$W4KvCgdBzhRBgZDnXf9s2/$rdrtKUhstflz5ADDB/w9WZc6M/sWlwqM76vKjaG3yV/";

        };
      };
    };
}
