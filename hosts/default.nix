{
  nixpkgs,
  home-manager,
  self,
  ...
} @ inputs: let
  framework = import ./framework;
  blade = import ./blade;

  base-options = {
    specialArgs = {inherit inputs self;};
    modules = [
      home-manager.nixosModules.home-manager
      ../impermanence.nix
      ../nixos.nix
      ../user.nix
    ];
  };
in {
  # My working laptop
  framework = nixpkgs.lib.nixosSystem (framework {
    inherit base-options;
    specialArgs = {inherit inputs;};
  });

  # My gaming and producing laptop
  # My working laptop
  blade = nixpkgs.lib.nixosSystem (blade {
    inherit base-options;
    specialArgs = {inherit inputs;};
  });
}
