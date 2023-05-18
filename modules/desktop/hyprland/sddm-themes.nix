{
  stdenv,
  fetchFromGitHub,
}: {
  catppuccino-sddm = stdenv.mkDerivation rec {
    pname = "catppuccino-sddm";
    version = "1.0";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src/src/catppuccin-mocha $out/share/sddm/themes/catppuccin-mocha
    '';
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "sddm";
      rev = "master";
      sha256 = "ceaK/I5lhFz6c+UafQyQVJIzzPxjmsscBgj8130D4dE=";
    };
  };
}
