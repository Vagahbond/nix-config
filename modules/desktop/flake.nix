{
  description = "Internal flake for passing desktops inputs";

  inputs = {
    eww-config = {
      url = "github:Vagahbond/eww-dotfiles";
      flake = false;
    };
  };

  outputs = {eww-config, ...}: {
    eww-config = eww-config;
  };
}
