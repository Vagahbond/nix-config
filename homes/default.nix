{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (config) rice;

  theme =
    if rice != null
    then
      import ./${rice}
      {
        inherit pkgs;
        nixCooker = inputs.nix-cooker.lib {
          inherit lib;
          inherit (config) theme;
        };
      }
    else {};
in {
  imports = [
    inputs.nix-cooker.nixosModules.default
    ./options.nix
  ];

  config = {inherit theme;};
}
