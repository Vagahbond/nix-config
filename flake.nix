{
  description = "My modular NixOS configuration that totally did not take countless horus to make.";
  outputs = {self, ...} @ inputs: {
    nixosConfigurations =
      import ./hosts
      {
        inherit inputs self;
      };

    # Building the documentation
    # TODO: Make it for several systems ?
    packages."x86_64-linux".doc = import ./doc {
      inherit inputs self;
    };
  };

  # Imagine having no clean way to separate your system's dependencies...
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

    schizofox = {
      url = "github:schizofox/schizofox";
    };

    eww-config = {
      url = "github:Vagahbond/eww-dotfiles";
      flake = false;
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    neovim-flake = {
      url = "github:NotAShelf/neovim-flake";
      # url = "github:vagahbond/neovim-flake";
    };

    anyrun.url = "github:Kirottu/anyrun";

    #    anyrun-nixos-options.url = "github:n3oney/anyrun-nixos-options";

    nix-gaming.url = "github:fufexan/nix-gaming";
  };
}
