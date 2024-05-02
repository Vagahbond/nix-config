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

    agenix.url = "github:yaxitech/ragenix";

    schizofox = {
      url = "github:schizofox/schizofox";
    };

    eww-config = {
      url = "github:Vagahbond/eww-dotfiles";
      flake = false;
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprpaper.url = "github:hyprwm/hyprpaper";

    hyprlock.url = "github:hyprwm/hyprlock";

    hypridle.url = "github:hyprwm/hypridle";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    neovim-flake = {
      url = "github:NotAShelf/neovim-flake";
    };

    anyrun.url = "github:Kirottu/anyrun";

    anyrun-nixos-options.url = "github:n3oney/anyrun-nixos-options";

    nix-gaming.url = "github:fufexan/nix-gaming";

    nix-cooker.url = "github:vagahbond/nix-cooker";
  };
}
