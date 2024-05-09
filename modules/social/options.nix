{lib, ...}:
with lib; {
  options.modules.social = {
    whatsapp.enable = mkEnableOption "whatsapp";
    teams.enable = mkEnableOption "teams";
    discord.enable = mkEnableOption "discord";
    matrix.enable = mkEnableOption "matrix";
  };
}
