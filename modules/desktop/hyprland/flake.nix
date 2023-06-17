{
  description = "Internal flake for passing hyprland rice inputs";

  inputs = {
    eww-config = {
      url = "github:Vagahbond/eww-dotfiles";
      flake = false;
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
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
