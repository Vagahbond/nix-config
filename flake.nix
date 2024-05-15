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

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?rev=cba1ade848feac44b2eda677503900639581c3f4&submodules=1";
    hyprland-testing.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    hyprpaper.url = "github:hyprwm/hyprpaper";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprspace = {
      url = "github:KZDKM/Hyprspace/8049b2794ca19d49320093426677d8c2911e7327";
      inputs.hyprland.follows = "hyprland";
    };

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    neovim-flake = {
      url = "github:NotAShelf/neovim-flake";
    };

    anyrun.url = "github:Kirottu/anyrun";

    anyrun-nixos-options.url = "github:n3oney/anyrun-nixos-options";

    nix-cooker.url = "github:vagahbond/nix-cooker";

    ags.url = "github:Aylur/ags";
  };
}
