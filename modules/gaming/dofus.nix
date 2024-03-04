{pkgs}:
with pkgs;
  appimageTools.wrapType2 {
    name = "dofus";
    src = fetchurl {
      url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
      hash = "sha256-a//NKw7NLx5o4CxV/b87J+/mtkwJcjeqLnc3e2guDrM=";
    };
    extraPkgs = pkgs:
      with pkgs; [
        wine-wayland
      ];
  }
