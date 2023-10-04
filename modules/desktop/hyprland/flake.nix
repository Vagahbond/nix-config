{
  description = "Internal flake for passing hyprland rice inputs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    eww-config = {
      url = "github:Vagahbond/eww-dotfiles";
      flake = false;
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    # eww = {
    #  url = "github:elkowar/eww";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.rust-overlay.follows = "rust-overlay";
    # };
  };

  outputs = {
    eww-config,
    hyprland,
    # eww,
    ...
  }: {
    inherit eww-config hyprland;
    # eww = eww;
  };
}
