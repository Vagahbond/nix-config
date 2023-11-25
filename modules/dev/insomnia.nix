{pkgs}:
with pkgs;
  appimageTools.wrapType2 {
    name = "insomnia";
    src = fetchurl {
      url = "https://github.com/Kong/insomnia/releases/download/core%408.4.5/Insomnia.Core-8.4.5.AppImage";
      hash = "sha256-xNR6ZVC/CC6jux323Y2VEaRHjIJu1YtOXZJj6bRm34M=";
    };
    # extraPkgs = pkgs:
    #   with pkgs; [
    #     wine-wayland
    #   ];
  }
