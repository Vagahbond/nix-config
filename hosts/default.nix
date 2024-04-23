{
  inputs,
  self,
  ...
}: let
  inherit (inputs) home-manager nixpkgs;

  systemNames = ["blade" "framework" "dedistonks" "dedistonks2"];

  base-options = {
    specialArgs = {inherit inputs self;};
    modules = [
      home-manager.nixosModules.home-manager
      ../nixos.nix
      ../user.nix
      ../homes
    ];
  };

  #live-options = {
  #  specialArgs = {inherit inputs self;};
  #  modules = [
  #    home-manager.nixosModules.home-manager
  #    ../nixos.nix
  #    ../user.nix
  #    ../live.nix
  #  ];
  #};

  mkSystem = sysName: nixpkgs.lib.nixosSystem ((import ./${sysName}) {inherit base-options;});

  #   mkLiveSystem = sysName: nixpkgs.lib.nixosSystem ((import ./${sysName}) {base-options = live-options;});

  systems = map (sysName: {${sysName} = mkSystem sysName;}) systemNames;
  #  liveSystems = map (sysName: {"${sysName}-live" = mkLiveSystem sysName;}) systemNames;

  mergedSystems = nixpkgs.lib.foldr (coming: final: final // coming) {} systems;
in
  mergedSystems
