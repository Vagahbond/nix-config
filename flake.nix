{
  description = "My modular NixOS configuration that totally did not take countless horus to make.";

  outputs = {self, ...} @ inputs: {
    nixosConfigurations =
      import ./hosts
      {
        inherit inputs self;
      };

    packages."x86_64-linux".doc = import ./doc {
      inherit inputs self;
    };
  };

  # Imagine having no clean way to separate your system's dependencies...
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
    };

    impermanence.url = "github:nix-community/impermanence";

    disko.url = "github:nix-community/disko";

    agenix.url = "github:ryantm/agenix";

    schizofox = {
      url = "github:schizofox/schizofox";
    };

    hyprpaper.url = "github:hyprwm/hyprpaper";

    spicetify-nix = {
      url = "github:gerg-l/spicetify-nix";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-flake = {
      url = "github:notashelf/nvf";
    };

    anyrun.url = "github:anyrun-org/anyrun";

    nix-cooker.url = "github:vagahbond/nix-cooker";

    ags.url = "/home/vagahbond/Projects/ags";

    # universe.url = "/home/vagahbond/Projects/uni-verse-production/";
    universe.url = "github:uni-verse-fm/uni-verse-production";
  };
}
