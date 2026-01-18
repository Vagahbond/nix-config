{
  inputs,
  self,
  ...
}:
let
  inherit (inputs) home-manager nixpkgs;

  nixosSystems = [
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
    {
      name = "platypute";
      archi = "x86_64-linux";
    }
  ];

  darwinSystems = [
    {
      name = "air";
      archi = "aarch64-darwin";
    }
  ];

  helpers = arch: import ../helpers.nix { inherit (nixpkgs.legacyPackages.${arch}) lib; };

  mkNixosSystem =
    sysName: sysArch:
    nixpkgs.lib.nixosSystem {
      system = sysArch;
      specialArgs = {
        inherit inputs self;
        helpers = helpers sysArch;
      };

      modules = [
        home-manager.nixosModules.home-manager
        inputs.agenix.nixosModules.default
        ../homes
        ../modules

        ./${sysName}/hardware-configuration.nix
        ./${sysName}/features.nix
      ];
    };

  mkDarwinSystem =
    sysName: sysArch:
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit inputs self;
        helpers = helpers sysArch;
      };

      modules = [
        inputs.agenix.darwinModules.default

        ./${sysName}/features.nix
      ];
    };

  mergeSystems =
    { systems, mkSystem }:
    nixpkgs.lib.foldr (coming: final: final // coming) { } (
      map (sys: { ${sys.name} = mkSystem sys.name sys.archi; }) systems
    );
in
{
  nixosSystems = mergeSystems {
    systems = nixosSystems;
    mkSystem = mkNixosSystem;
  };
  darwinSystems = mergeSystems {
    systems = darwinSystems;
    mkSystem = mkDarwinSystem;
  };
}
