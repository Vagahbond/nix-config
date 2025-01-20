{pkgs}:
with pkgs;
  appimageTools.wrapType2 {
    pname = "dofus";
    version = "1.0";
    src = fetchurl {
      url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
      hash = "sha256-iNnpcrp5gmOKqA+cjEqslzBFtU2+Nn7ZL8t0qSaWfhA=";
    };
    extraPkgs = pkgs:
      with pkgs; [
        wine-wayland
      ];
  }
