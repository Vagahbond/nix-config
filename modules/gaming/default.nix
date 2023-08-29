{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  graphics = config.modules.graphics;

  cfg = config.modules.gaming;
in {
  options.modules.gaming = {
    dofus.enable = mkEnableOption "Enable Dofus";
  };

  config = mkIf (cfg.dofus.enable
    && (graphics.type != null)) {
    environment.systemPackages = with pkgs; [
      (
        appimageTools.wrapType2 {
          name = "dofus";
          src = fetchurl {
            url = "https://launcher.cdn.ankama.com/installers/production/Dofus-Setup-x86_64.AppImage";
            hash = "sha256-c+glEHi1WQA2IJvsp1+CO/YN2zKPFrMQ15mE7F162EU=";
          };
          # extraPkgs = pkgs: with pkgs; [ ];
        }
      )
      (
        writeTextDir "share/applications/dofus.desktop" ''
          [Desktop Entry]
          Version=2.68
          Type=Application
          Name=Dofus
          Exec=dofus
          StartupWMClass=AppRun
        ''
      )
    ];
  };
}
