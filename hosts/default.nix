{
  inputs,
  self,
  ...
}: let
  inherit (inputs) home-manager nixpkgs;

  systemNames = ["blade" "framework" "dedistonks"];

  base-options = {
    specialArgs = {inherit inputs self;};
    modules = [
      home-manager.nixosModules.home-manager
      ../impermanence.nix
      ../nixos.nix
      ../user.nix
    ];
  };

  live-options = {
    specialArgs = {inherit inputs self;};
    modules = [
      home-manager.nixosModules.home-manager
      ../impermanence.nix
      ../nixos.nix
      ../user.nix
      ../live.nix
    ];
  };

  mkSystem = sysName: nixpkgs.lib.nixosSystem ((import ./${sysName}) {inherit base-options;});

  mkLiveSystem = sysName: nixpkgs.lib.nixosSystem ((import ./${sysName}) {base-options = live-options;});

  systems = map (sysName: {${sysName} = mkSystem sysName;}) systemNames;
  liveSystems = map (sysName: {"${sysName}-live" = mkLiveSystem sysName;}) systemNames;

  mergedSystems = nixpkgs.lib.foldr (coming: final: final // coming) {} (systems ++ liveSystems);
in
  mergedSystems
