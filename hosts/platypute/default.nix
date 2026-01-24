# nh os switch --dry --build-host platypute --target-host platypute --hostname platypute . --show-trace
{
  name = "platypute";
  platform = "x86_64-linux";

  configuration =
    { inputs }:
    {

      imports = [
        inputs.disko.nixosModules.disko
        ./hardware-configuration.nix
        ./disk-config.nix
      ];
      system.stateVersion = "22.11"; # Did you read the comment?
    };
}
