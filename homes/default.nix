{
  lib,
  config,
  inputs,
  pkgs,
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
        inherit pkgs inputs;
        nixCooker = inputs.nix-cooker.lib {
          inherit lib;
          inherit (config) theme;
        };
      })
      theme
      ;
  };
}
