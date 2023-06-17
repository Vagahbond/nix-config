{
  description = "Internal flake for passing desktops inputs";

  inputs = {
    hyprland-rice = {
      url = "./hyprland";
    };
  };

  outputs = {hyprland-rice, ...}: {
    hyprland-rice = hyprland-rice;
  };
}
