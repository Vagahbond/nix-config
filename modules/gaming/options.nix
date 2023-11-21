{lib, ...}:
with lib; {
  options.modules.gaming = {
    optimisations.enable = mkEnableOption "Various optimisations";
    steering-wheel.enable = mkEnableOption "Steering wheel modules";
    wine.enable = mkEnableOption "Enable vanilla wine";
    dofus.enable = mkEnableOption "Enable Dofus";
    steam.enable = mkEnableOption "Enable Steam";
    minecraft.enable = mkEnableOption "Enable minecraft";
    tlauncher.enable = mkEnableOption "Enable tlauncher, unoficial legal(in minecraft) version of minecraft";
  };
}
