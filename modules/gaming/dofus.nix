{pkgs}:
with pkgs;
  appimageTools.wrapType2 {
    name = "dofus";
    src = fetchurl {
      url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
      hash = "sha256-ZVw7N/Jf6aF9kfZseh+J74UkGYDo7JEvZJmOPA2zojo=";
    };
    extraPkgs = pkgs:
      with pkgs; [
        wine-wayland
      ];
  }
