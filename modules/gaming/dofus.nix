{pkgs}:
with pkgs;
  appimageTools.wrapType2 {
    name = "dofus";
    src = fetchurl {
      url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
      hash = "sha256-l8yR0yPMJ6ar0YSsB8D0WS+7iuFhT4x2GMOYsHv8/jE=";
    };
    extraPkgs = pkgs:
      with pkgs; [
        wine-wayland
      ];
  }
