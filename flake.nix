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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
    };

    impermanence.url = "github:nix-community/impermanence";

    disko.url = "github:nix-community/disko";

    agenix.url = "github:yaxitech/ragenix";

    schizofox = {
      url = "github:schizofox/schizofox";
    };

    eww-config = {
      url = "github:Vagahbond/eww-dotfiles";
      flake = false;
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=9a09eac79b85c846e3a865a9078a3f8ff65a9259";

    hyprpaper.url = "github:hyprwm/hyprpaper";

    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
    spicetify-nix = {
      url = "github:gerg-l/spicetify-nix";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-flake = {
      url = "github:NotAShelf/nvf";
    };

    anyrun.url = "github:anyrun-org/anyrun";

    anyrun-websearch.url = "github:FromWau/plugin-websearch";

    nix-cooker.url = "github:vagahbond/nix-cooker";

    ags.url = "github:Aylur/ags/bb91f7c8fdd2f51c79d3af3f2881cacbdff19f60";

    # universe.url = "/home/vagahbond/Projects/uni-verse-production/";
    universe.url = "github:uni-verse-fm/uni-verse-production";
  };
}
