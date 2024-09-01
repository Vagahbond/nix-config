{pkgs}:
with pkgs;
  appimageTools.wrapType2 {
    name = "dofus";
    src = fetchurl {
      url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
      hash = "sha256-07hinxrV8M0AyIQQXZyzJZjImi1dQDtgPmPQXY74VKw=";
    };
    extraPkgs = pkgs:
      with pkgs; [
        wine-wayland
      ];
  }
