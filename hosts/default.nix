{
  nixpkgs,
  home-manager,
  ...
} @ inputs: let
  framework = import ./framework;

  base-options = {
    specialArgs = {inherit inputs;};
    modules = [
      home-manager.nixosModules.home-manager

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
  # blade = import ./blade; Not yet ready
}
