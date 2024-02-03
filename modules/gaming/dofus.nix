{pkgs}:
with pkgs;
  appimageTools.wrapType2 {
    name = "dofus";
    src = fetchurl {
      url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
      hash = "sha256-gJPpaDm+pOhWvTcO6Hg0H9c5s/by6yoaQ3mKtLSXI/4=";
    };
    extraPkgs = pkgs:
      with pkgs; [
        wine-wayland
      ];
  }
