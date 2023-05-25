{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  graphics = config.modules.graphics;

  cfg = config.modules.browser;
in {
  options.modules.browser.firefox = {
    enable = mkOption {
      # if yours is missing, don't hesitate to PR
      type = types.bool;
      description = "Enable or not Firefox. Enabled by default.";
      default = true;
      example = false;
    };
  };

  config = mkIf (cfg.firefox.enable && (graphics.type != null)) {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-wayland;
      preferences = {
        "extensions.webextensions.uuids" = ''
          {
            "formautofill@mozilla.org":"c4c84d9d-e6cf-4893-aa3c-fb752044a768",
            "pictureinpicture@mozilla.org":"5938d127-0a12-4ea5-9261-215c125379a3",
            "screenshots@mozilla.org":"bd5ec6ec-55d1-4d30-b8ec-ed6e9aac330f",
            "webcompat-reporter@mozilla.org":"0f458894-adfb-416f-88e0-4526652da59e",
            "webcompat@mozilla.org":"8e4c7cd6-8f2b-48d1-aa47-945c63316219",
            "default-theme@mozilla.org":"02f6d128-5593-4594-867c-039fe04e2945",
            "addons-search-detection@mozilla.com":"085a8b37-640f-428a-8765-6eeb963a1531",
            "google@search.mozilla.org":"c179af5a-0b0f-4e42-a9b2-b71dcd2590a0",
            "wikipedia@search.mozilla.org":"089f100c-c9a1-49f2-8866-ad3e90408101",
            "bing@search.mozilla.org":"689c37c3-5e55-46bc-9454-bc37170336d9",
            "ddg@search.mozilla.org":"b69e36f8-0082-44b0-af85-a4993551c049",
            "amazon@search.mozilla.org":"19c2e87f-c207-4ab5-9ef9-58865b91e0fc",
            "adblockultimate@adblockultimate.net":"9da0d283-b210-4807-adc9-51f5b5ca4366",
            "addon@darkreader.org":"3facab32-de37-4b3e-b6ed-96c3aa08d067",
            "{446900e4-71c2-419f-a6a7-df9c091e268b}":"84cf9871-ad84-4b37-80d4-afa315ee7ebd",
            "pywalfox@frewacom.org":"4a4ada26-0954-465c-bb5d-8c186d46a280",
            "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}":"1bd7e8da-7ea0-4d3c-81ae-cd6be9439892"
          }
        '';
        "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["adblockultimate_adblockultimate_net-browser-action","pywalfox_frewacom_org-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","customizableui-special-spring1","urlbar-container","search-container","customizableui-special-spring2","save-to-pocket-button","downloads-button","fxa-toolbar-menu-button","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","addon_darkreader_org-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","adblockultimate_adblockultimate_net-browser-action","addon_darkreader_org-browser-action","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","pywalfox_frewacom_org-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar","unified-extensions-area"],"currentVersion":18,"newElementCount":2}'';
        "extensions.webextensions.ExtensionStorageIDB.migrated.{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = true;
        "extensions.webextensions.ExtensionStorageIDB.migrated.{446900e4-71c2-419f-a6a7-df9c091e268b}" = true;
        "extensions.webextensions.ExtensionStorageIDB.migrated.screenshots@mozilla.org" = true;
        "extensions.webextensions.ExtensionStorageIDB.migrated.pywalfox@frewacom.org" = true;
        "extensions.webextensions.ExtensionStorageIDB.migrated.addon@darkreader.org" = true;
        "extensions.webextensions.ExtensionStorageIDB.migrated.adblockultimate@adblockultimate.net" = true;
        "extensions.webcompat.perform_ua_overrides" = true;
        "extensions.webcompat.perform_injections" = true;
        "extensions.webcompat.enable_shims" = true;
        "extensions.ui.theme.hidden" = false;
        "extensions.ui.sitepermission.hidden" = true;
        "extensions.ui.locale.hidden" = true;
        "extensions.ui.extension.hidden" = false;
        "extensions.ui.dictionary.hidden" = true;
        "extensions.ui.lastCategory" = "addons://list/extension";
        "extensions.systemAddonSet" = ''
          {"schema":1,"addons":{}}
        '';
        "extensions.pictureinpicture.enable_picture_in_picture_overrides" = true;
        "extensions.pendingOperations" = false;
        "extensions.lastAppBuildId" = 20230302170652;
        "extensions.getAddons.databaseSchema" = 6;
        "extensions.activeThemeID" = "default-theme@mozilla.org";
        "extensions.databaseSchema" = 35;
      };
      preferencesStatus = "default";
    };
  };
}
