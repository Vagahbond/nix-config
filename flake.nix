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

    ags.url = "github:vagahbond/ags-bar";

    universe.url = "github:uni-verse-fm/uni-verse-production";

    learnify = {
      url = "git+ssh://git@github.com/vagahbond/learnify-platform";
    };

    website = {
      url = "github:vagahbond/website";
      flake = false;
    };

    blog-contents = {
      url = "github:vagahbond/blog";
      flake = false;
    };

    blog-theme = {
      url = "github:athul/archie";
      flake = false;
    };
  };
}
