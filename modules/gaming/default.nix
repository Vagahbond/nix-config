{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  inherit (config.modules) graphics;

  cfg = config.modules.gaming;

  dofus = with pkgs;
    appimageTools.wrapType2 {
      name = "dofus";
      src = fetchurl {
        url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
        hash = "sha256-c+glEHi1WQA2IJvsp1+CO/YN2zKPFrMQ15mE7F162EU=";
      };
      extraPkgs = pkgs:
        with pkgs; [
          wine-wayland
        ];
    };
in {
  options.modules.gaming = {
    wine.enable = mkEnableOption "Enable vanilla wine";
    dofus.enable = mkEnableOption "Enable Dofus";
  };

  config = mkMerge [
    (mkIf (cfg.dofus.enable
      && (graphics.type != null)) {
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
