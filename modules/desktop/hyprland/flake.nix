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

    eww = {
      url = "github:elkowar/eww";
    };
  };

  outputs = {
    eww-config,
    hyprland,
    eww,
    ...
  }: {
    eww-config = eww-config;
    hyprland = hyprland;
    eww = eww;
  };
}
