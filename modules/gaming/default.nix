{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  inherit (config.modules) graphics impermanence;

  username = import ../../username.nix;

  cfg = config.modules.gaming;

  dofus = with pkgs;
    appimageTools.wrapType2 {
      name = "dofus";
      src = fetchurl {
        url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
        hash = "sha256-QXPW+Rx6csom9GWii7KomSpPlyAAlSrapuPlIzhpLGs=";
      };
      extraPkgs = pkgs:
        with pkgs; [
          wine-wayland
        ];
    };
in {
  imports = [./options.nix];

  config = mkMerge [
    (mkIf (cfg.dofus.enable
      && (graphics.type != null)) {
      environment.persistence.${impermanence.storageLocation} = {
        users.${username} = {
          directories = [
            "Ankama"
            "Ankama Launcher"
          ];
        };
      };

      environment.systemPackages = [
        dofus
        (
          pkgs.writeTextDir "share/applications/dofus.desktop" ''
            [Desktop Entry]
            Version=2.68
            Type=Application
            Name=Dofus
            Exec=dofus
            StartupWMClass=AppRun
          ''
        )
      ];
    })
    (
      mkIf (cfg.wine.enable && (graphics.type != null)) {
        environment.systemPackages = [
          wine-wayland
        ];
      }
    )
  ];
}
