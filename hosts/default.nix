{
  inputs,
  self,
  ...
}: let
  inherit (inputs) home-manager nixpkgs;

  systemNames = ["framework" "dedistonks"];

  mkSystem = sysName:
    nixpkgs.lib.nixosSystem {
      # TODO: move this to the host itself
      system = "x86_64-linux";
      specialArgs = {inherit inputs self;};

      modules = [
        home-manager.nixosModules.home-manager
        inputs.agenix.nixosModules.default
        ../nixos.nix
        ../user.nix
        ../homes
        ../modules

        ./${sysName}/hardware-configuration.nix
        ./${sysName}/features.nix
      ];
    };

  systems = map (sysName: {${sysName} = mkSystem sysName;}) systemNames;

  mergedSystems = nixpkgs.lib.foldr (coming: final: final // coming) {} systems;
in
  mergedSystems
