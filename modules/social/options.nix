{lib, ...}:
with lib; {
  options.modules.social = {
    whatsapp.enable = mkEnableOption "Enable whatsapp";
    teams.enable = mkEnableOption "Enable teams";
    discord.enable = mkEnableOption "Enable discord";
    matrix.enable = mkEnableOption "Enable matrix";
  };
}
