{pkgs}:
with pkgs;
  appimageTools.wrapType2 {
    name = "dofus";
    src = fetchurl {
      url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
      hash = "sha256-6dPgOTUxLzUDlKOXo38bS/M68NUsZJFH8cC1KXqHRfk=";
    };
    extraPkgs = pkgs:
      with pkgs; [
        wine-wayland
      ];
  }
