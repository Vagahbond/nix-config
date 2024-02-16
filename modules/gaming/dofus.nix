{pkgs}:
with pkgs;
  appimageTools.wrapType2 {
    name = "dofus";
    src = fetchurl {
      url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
      hash = "sha256-rYUfHtYpiHUSzxPcUHhyriIVO0GWMXIxmwC3ldJe2CY=";
    };
    extraPkgs = pkgs:
      with pkgs; [
        wine-wayland
      ];
  }
