{pkgs}:
with pkgs;
  appimageTools.wrapType2 {
    name = "dofus";
    src = fetchurl {
      url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
      hash = "sha256-ssCjFrQYI/pxnsjcy1xLSpuGGy0NGMOcNP9RiNDhE/w=";
    };
    extraPkgs = pkgs:
      with pkgs; [
        wine-wayland
      ];
  }
