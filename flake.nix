{
  description = "My modular NixOS configuration that totally did not take countless horus to make.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    # Impermanence ensures I have a **mostly** replicable system
    impermanence.url = "github:nix-community/impermanence";

    # Secrets management via ragenix, an agenix replacement
    agenix.url = "github:yaxitech/ragenix";

    # Internal flakes
    internalFlakes.url = "./modules";
  };

  outputs = {
    nixpkgs,
    home-manager,
    impermanence,
    internalFlakes,
    agenix,
    ...
  } @ inputs: {
    nixosConfigurations = import ./hosts {
      inherit home-manager impermanence agenix internalFlakes inputs nixpkgs;
    };
  };
}
