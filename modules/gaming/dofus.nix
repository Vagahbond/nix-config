{pkgs}:
with pkgs;
  appimageTools.wrapType2 {
    name = "dofus";
    src = fetchurl {
      url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
      hash = "sha256-q8i3DW+tCXhwVW7b15cWkQyngNbvpFSiCxlMm3aUJYA=";
    };
    extraPkgs = pkgs:
      with pkgs; [
        wine-wayland
      ];
  }
