{lib, ...}:
with lib; {
  options.modules.productivity = {
    notion.enable = mkEnableOption "Enable Notion"; # No worky
    appflowy.enable = mkEnableOption "Enable appflowy"; # Notion alternative
    nextcloudSync = {
      enable = mkEnableOption "Enable next cloud syncronisation";
    };
    pomodoro.enable = mkEnableOption "Enable pomodoro app";
    anytype.enable = mkEnableOption "Enable Anytype";
    logseq.enable = mkEnableOption "Enable LogSeq";
    activityWatch.enable = mkEnableOption "Enable AW";
  };
}
