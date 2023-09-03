{
  description = "Internal flake for passing desktops inputs";

  inputs = {
    hyprland-rice = {
      url = "./hyprland";
    };
  };

  outputs = {hyprland-rice, ...}: {
    inherit hyprland-rice;
  };
}
