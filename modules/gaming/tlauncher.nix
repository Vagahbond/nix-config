{pkgs}:
with pkgs;
  stdenv.mkDerivation {
    name = "tlauncher";

    nativeBuildInputs = with pkgs; [
      unzip
      jdk17
    ];

    src = fetchurl {
      url = "https://dl2.tlauncher.org/f.php?f=files%2FTLauncher-2.885.zip";
      hash = "sha256-BvsEjdO88vd0OYil5QcTngXZA+7TMLy6frPt6DILxVU=";
    };
    sourceRoot = "./";
    installPhase = ''
      ls
      mkdir $out
      mv TLauncher-*.jar $out/TLauncher.jar
    '';
  }
