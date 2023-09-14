{lib, ...}:
with lib; {
  options.modules.productivity = {
    notion.enable = mkEnableOption "Enable Notion"; # No worky
    appflowy = mkEnableOption "Enable appflowy"; # Notion alternative
  };
}
