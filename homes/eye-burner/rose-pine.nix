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
      cp $src $out/wallpaper.jpg
    '';

    src = fetchurl {
      url = "https://github.com/Filippo39/.dotfiles/blob/main/Wallpapers/japan.jpg?raw=true";
      sha256 = "sha256-CYrC+HUSM+fQUlvtfEA24FoZ9OvCRNBj6gf1gnoSgBM=";
    };
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
      cp ${wallpaper}/wallpaper.jpg ./corners/backgrounds/background.jpg
      echo '${sddm-config}' > ./corners/theme.conf
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/sddm/themes
      cp -R ./corners $out/share/sddm/themes/rose-pine

      runHook postInstall
    '';
  };

  gtk-theme = stdenv.mkDerivation {
    pname = "rose-pine-gtk";
    version = "1.0";
    buildInputs = with pkgs; [sassc dos2unix];
    dontBuild = true;
    installPhase = ''
      runHook preInstall

      cp -r $src/themes ./themes

      dos2unix ./themes/install.sh

      mkdir -p $out/share/themes/
      bash ./themes/install.sh  \
        -n Rose-Pine            \
        -c light                \
        -d $out/share/themes/   \
        --tweaks macos

      mkdir -p $out/share/icons/

      cp -aR $src/icons/* $out/share/icons/

      runHook postInstall
    '';

    src = fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Rose-Pine-GTK-Theme";
      rev = "master";
      sha256 = "sha256-057eGlV07oKo/64fMm9QVaFxfrkG5vkr+qIY7Pf8tLo=";
    };
  };
}
