{pkgs}:
with pkgs;
  appimageTools.wrapType2 {
    name = "dofus";
    src = fetchurl {
      url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
      hash = "sha256-1uHVvZ2n1/bk4tUr9zrvEl0oLto6L/1egI9FzJRtzyQ=";
    };
    extraPkgs = pkgs:
      with pkgs; [
        wine-wayland
      ];
  }
