{pkgs}:
with pkgs;
  appimageTools.wrapType2 {
    name = "dofus";
    src = fetchurl {
      url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
      hash = "sha256-PiF85siKJHaNUNy2iV6Apys9eibntjwgHIHdL/UVT7s=";
    };
    extraPkgs = pkgs:
      with pkgs; [
        wine-wayland
      ];
  }
