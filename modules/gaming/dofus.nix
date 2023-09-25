{pkgs}:
with pkgs;
  appimageTools.wrapType2 {
    name = "dofus";
    src = fetchurl {
      url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
      hash = "sha256-qzQCEg959hIowko+MqEbxLEUYarogxb0EJvn69BGMcU=";
    };
    extraPkgs = pkgs:
      with pkgs; [
        wine-wayland
      ];
  }
