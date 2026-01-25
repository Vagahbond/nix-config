# nh os switch --dry --build-host platypute --target-host platypute --hostname platypute . --show-trace
{
  name = "platypute";
  platform = "x86_64-linux";

  configuration = _: {

    imports = [
      ./hardware-configuration.nix
    ];
    system.stateVersion = "22.11"; # Did you read the comment?
  };
}
