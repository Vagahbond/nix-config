{lib, ...}:
with lib; {
  options.modules.gaming = {
    wine.enable = mkEnableOption "Enable vanilla wine";
    dofus.enable = mkEnableOption "Enable Dofus";
    steam.enable = mkEnableOption "Enable Steam";
    minecraft.enable = mkEnableOption "Enable minecraft";
  };
}
