{pkgs}:
with pkgs;
  appimageTools.wrapType2 {
    name = "dofus";
    src = fetchurl {
      url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
      hash = "sha256-8nKgLvRt1kRR1GAO3xDN/dYXVzXhUwUX7IdMUcOI2Rs=";
    };
    extraPkgs = pkgs:
      with pkgs; [
        wine-wayland
      ];
  }
