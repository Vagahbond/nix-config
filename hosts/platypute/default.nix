# nh os switch --dry --build-host platypute --target-host platypute --hostname platypute . --show-trace
{
  name = "platypute";
  platform = "x86_64-linux";

  configuration =
    { username }:
    {

      imports = [
        ./hardware-configuration.nix
      ];

      system.stateVersion = "22.11"; # Did you read the comment?

      users.users.${username}.hashedPassword =
        "$y$j9T$wNFGGvQeqSgVUXxTmOHX8.$wd5iVM5t01vuyNKR.bEcwBZIQ.t8qIxhPylDzhRYDC0";

    };
}
