{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; let
  inherit (config.modules) graphics impermanence;
  cfg = config.modules.browser;

  username = import ../../username.nix;

  inherit (config.theme) colors font;

  inherit
    (inputs.nix-cooker.lib {
      inherit lib;
      inherit (config) theme;
    })
    mkHex
    ;
in {
  imports = [
    ./options.nix
  ];

  config = mkMerge [
    (mkIf
      (cfg.chromium.enable && (graphics.type != null))
      {
        environment = {
          persistence.${impermanence.storageLocation} = {
            users.${username} = {
              directories = [
                ".config/chromium"
                ".cache/chromium"
              ];
            };
          };
          systemPackages = with pkgs; [
            chromium
          ];
        };
      })
    (mkIf
      (cfg.firefox.enable && (graphics.type != null))
      {
        xdg.mime.defaultApplications = {
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/about" = "firefox.desktop";
          "x-scheme-handler/unknown" = "firefox.desktop";
        };
        environment.persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".mozilla"
              ".cache/mozilla"
            ];
          };
        };

        programs.firefox.enable = true;
      })
  ];
}
