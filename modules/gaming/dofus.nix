{pkgs}:
with pkgs;
  appimageTools.wrapType2 {
    name = "dofus";
    src = fetchurl {
      url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
      hash = "sha256-W4zOaAaMaTE2OjJtm/A9PsCk3Ph6mKsu5Zym6cuUnlE=";
    };
    extraPkgs = pkgs:
      with pkgs; [
        wine-wayland
      ];
  }
