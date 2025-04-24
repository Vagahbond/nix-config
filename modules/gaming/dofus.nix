{pkgs}:
with pkgs;
/*
  stdenv.mkDerivation {
  pname = "dofus";
  version = "1.0";
  dontBuild = true;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src $out/bin/dofus.appimage
    runHook postInstall
  '';

  postInstall = ''
    chmod +x $out/bin/dofus.appimage
  '';

  src = fetchurl {
    url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
    sha256 = "sha256-D1SYKY7hnkUjTrxlsKyvFpw9SXTSuPn2XPrh+6CnOfk=";
  };
}
*/
  appimageTools.wrapType2 {
    pname = "dofus";
    version = "1.0";
    src = fetchurl {
      url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
      hash = "sha256-ghDzxiimXe3IJfUl44kxARp3GhIslMmfvbru1PklVzk=";
    };
    extraPkgs = pkgs:
      with pkgs; [
        wine
        sentry-native
      ];
  }
