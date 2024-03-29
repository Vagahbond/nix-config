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
      sha256 = "sha256-0zoJOTFjQq3gm5i3xCRbyk781kB7BqcWWNrrIkWf2Xk=";
    };
  };
}
