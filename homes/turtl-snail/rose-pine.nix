{
  stdenv,
  fetchFromGitHub,
  fetchurl,
  stdenvNoCC,
  libsForQt5,
}: rec {
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

  wallpaper = stdenv.mkDerivation {
    pname = "wallpaper";
    version = "1.0";
    dontBuild = true;
    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/assets
      cp $src $out/wallpaper.jpg
    '';

    src = fetchurl {
      url = "https://images4.alphacoders.com/235/thumb-1920-235538.jpg";
      sha256 = "sha256-6sOlxZ3etn7zvv7R+OC+KY63sUsU/SiV/ZOeNugl1to=";
    };
  };

  sddm-theme = stdenvNoCC.mkDerivation rec {
    pname = "sddm-rose-pine-theme";
    version = "1.2";

    propagatedUserEnvPkgs = [
      libsForQt5.qt5.qtgraphicaleffects
    ];

    src = fetchFromGitHub {
      owner = "lwndhrst";
      repo = "sddm-rose-pine";
      rev = "v${version}";
      sha256 = "+WOdazvkzpOKcoayk36VLq/6lLOHDWkDykDsy8p87JE=";
    };

    buildPhase = ''
      cp ${wallpaper}/wallpaper.jpg ./background.jpg
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/sddm/themes
      cp -R ./ $out/share/sddm/themes/rose-pine

      runHook postInstall
    '';
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
