{
  stdenv,
  fetchurl,
}: {
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
}
