{
  pkgs,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  stdenvNoCC,
  libsForQt5,
  sddm-config,
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
      cp $src $out/wallpaper.png
    '';

    src = ./wallpaper.png;
  };

  sddm-theme = stdenvNoCC.mkDerivation {
    pname = "sddm-theme";
    version = "1";

    propagatedUserEnvPkgs = [
      libsForQt5.qt5.qtgraphicaleffects
    ];

    src = fetchFromGitHub {
      owner = "aczw";
      repo = "sddm-theme-corners";
      rev = "main";
      sha256 = "sha256-CPK3kbc8lroPU8MAeNP8JSStzDCKCvAHhj6yQ1fWKkY=";
    };

    buildPhase = ''
      cp ${wallpaper}/wallpaper.png ./corners/backgrounds/background.png
      echo '${sddm-config}' > ./corners/theme.conf
      echo 'QtVersion=5' > ./corners/metadata.desktop
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/sddm/themes
      cp -R ./corners $out/share/sddm/themes/theme

      runHook postInstall
    '';
  };

  gtk-theme = stdenv.mkDerivation {
    pname = "everforest-gtk";
    version = "1.0";
    buildInputs = with pkgs; [sassc dos2unix];
    dontBuild = true;
    installPhase = ''
      runHook preInstall

      cp -r $src/themes ./themes

      dos2unix ./themes/install.sh

      mkdir -p $out/share/themes/
      bash ./themes/install.sh  \
        -c light                \
        -t green                \
        -d $out/share/themes/

      mkdir -p $out/share/icons/

      cp -aR $src/icons/* $out/share/icons/

      runHook postInstall
    '';

    src = fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Everforest-GTK-Theme";
      rev = "master";
      sha256 = "sha256-XHO6NoXJwwZ8gBzZV/hJnVq5BvkEKYWvqLBQT00dGdE=";
    };
  };
}
