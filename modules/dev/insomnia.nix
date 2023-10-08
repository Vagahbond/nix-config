{pkgs}:
with pkgs;
  appimageTools.wrapType2 {
    name = "insomnia";
    src = fetchurl {
      url = "https://github.com/Kong/insomnia/releases/download/core%408.2.0/Insomnia.Core-8.2.0.AppImage";
      hash = "sha256-dFChunEzfCIN+TvKuKRpdKdF2lwne7hzAPASY4dQQy0=";
    };
    # extraPkgs = pkgs:
    #   with pkgs; [
    #     wine-wayland
    #   ];
  }
