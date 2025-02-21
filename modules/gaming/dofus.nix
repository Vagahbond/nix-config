{pkgs}:
with pkgs;
  appimageTools.wrapType2 {
    pname = "dofus";
    version = "1.0";
    src = fetchurl {
      url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
      hash = "sha256-D1SYKY7hnkUjTrxlsKyvFpw9SXTSuPn2XPrh+6CnOfk=";
    };
    extraPkgs = pkgs:
      with pkgs; [
        wine-wayland
        sentry-native
      ];
  }
