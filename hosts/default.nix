{
  nixpkgs,
  home-manager,
  self,
  ...
} @ inputs: let
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

  mkSystem = sysName: nixpkgs.lib.nixosSystem ((import ./${sysName}) {inherit base-options;});
  mkLiveSystem = sysName:
    nixpkgs.lib.nixosSystem ((import ./${sysName}) {
      inherit base-options;
      modules = [../live.nix];
    });

  systems = map (sysName: {${sysName} = mkSystem sysName;}) systemNames;
  liveSystems = map (sysName: {"${sysName}-live" = mkLiveSystem sysName;}) systemNames;

  mergedSystems = nixpkgs.lib.foldr (coming: final: final // coming) {} (systems ++ liveSystems);
in
  mergedSystems
