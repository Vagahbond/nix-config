{
  inputs,
  self,
  ...
}: let
  inherit (inputs) home-manager nixpkgs;

  systemNames = [
    {
      name = "framework";
      archi = "x86_64-linux";
    }
    {
      name = "dedistonks";
      archi = "x86_64-linux";
    }
    {
      name = "live";
      archi = "x86_64-linux";
    }
  ];

  mkSystem = sysName: sysArch:
    nixpkgs.lib.nixosSystem {
      # TODO: move this to the host itself
      system = sysArch;
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

  systems = map (sys: {${sys.name} = mkSystem sys.name sys.archi;}) systemNames;

  mergedSystems = nixpkgs.lib.foldr (coming: final: final // coming) {} systems;
in
  mergedSystems
