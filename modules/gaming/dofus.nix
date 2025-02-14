{pkgs}:
with pkgs;
  appimageTools.wrapType2 {
    pname = "dofus";
    version = "1.0";
    src = fetchurl {
      url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
      hash = "sha256-NT4tIQKJr1P+bpDMmRwi63aEsB+CKyU+B4SF68eLU4k=";
    };
    extraPkgs = pkgs:
      with pkgs; [
        wine-wayland
      ];
  }
