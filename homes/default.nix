{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (config) rice;
in {
  imports = [
    inputs.nix-cooker.nixosModules.default
    ./options.nix
  ];

  config = {
    inherit
      (import ./${rice} {
        inherit lib;
        nixCooker = inputs.nix-cooker.nixosModules.default;
      })
      theme
      ;
  };
}
