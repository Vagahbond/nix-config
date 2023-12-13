{
  stdenv,
  fetchFromGitHub,
}: {
  catppuccino-sddm = stdenv.mkDerivation {
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
      sha256 = "sha256-Jf4xfgJEzLM7WiVsERVkj5k80Fhh1edUl6zsSBbQi6Y=";
    };
  };
}
