{lib, ...}:
with lib; {
  options.modules.productivity = {
    notion.enable = mkEnableOption "Enable Notion"; # No worky
    appflowy.enable = mkEnableOption "Enable appflowy"; # Notion alternative
    nextcloudSync = {
      enable = mkEnableOption "Enable next cloud syncronisation";
    };
    pomodoro.enable = mkEnableOption "Enable pomodoro app";
  };
}
