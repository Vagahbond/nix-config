{
  stdenv,
  fetchFromGitHub,
}: {
  rose-pine-hyprcursor = stdenv.mkDerivation {
    pname = "rose-pine-hyprcursor";
    version = "1.0";
    dontBuild = true;
    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/icons/rose-pine-hyprcursor
      cp -aR $src/* $out/share/icons/rose-pine-hyprcursor

      runHook postInstall
    '';
    src = fetchFromGitHub {
      owner = "ndom91";
      repo = "rose-pine-hyprcursor";
      rev = "master";
      sha256 = "sha256-wLuFLI6S5DOretqJN05+kvrs8cbnZKfVLXrJ4hvI/Tg=";
    };
  };
  gtk-theme = stdenv.mkDerivation {
    pname = "rose-pine-gtk";
    version = "1.0";
    dontBuild = true;
    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/icons/
      mkdir -p $out/share/themes/

      cp -aR $src/icons/* $out/share/icons/
      cp -aR $src/themes/* $out/share/themes/

      runHook postInstall
    '';

    src = fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Rose-Pine-GTK-Theme";
      rev = "master";
      sha256 = "sha256-I9UnEhXdJ+HSMFE6R+PRNN3PT6ZAAzqdtdQNQWt7o4Y=";
    };
  };
}
