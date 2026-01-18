{
  pkgs,
  lib,
  config,
  helpers,
  ...
}:
with lib;
let
  username = import ../../username.nix;

  inherit (config.modules) graphics impermanence;

  cfg = config.modules.dev;
in
{
  imports = [ ./options.nix ];

  config = mkMerge [
    (mkIf cfg.enable {
      environment = {
        systemPackages = with pkgs; [
          lazygit
          gh
        ];

      }
      // lib.optionalAttrs config.modules.impermanence.enable {
        persistence.${impermanence.storageLocation} =

          {
            users.${username} = {
              directories = [
                ".config/lazygit"
                ".config/gh"
              ];
            };
          };
      };

      /*
        programs = {
          git = {
            enable = true;
            config = {
              user = {
                name = "Yoni FIRROLONI";
                email = "pro@yoni-firroloni.com";
              };
              init = {
                defaultBranch = "master";
              };
              url = {
                "https://github.com/" = {
                  insteadOf = [
                    "gh:"
                    "github:"
                  ];
                };
              };
            };
          };
        };
      */

    })
    (mkIf (cfg.enable && cfg.enableNetwork) {
      environment.systemPackages = with pkgs; [
        wget
        curlWithGnuTls
      ];
    })
    (mkIf (cfg.enable && cfg.dbManager.enable) {

      environment.systemPackages = with pkgs; [
        lazysql
      ];
    })
    (mkIf (cfg.enable && cfg.enableNetwork && graphics != null) {
      environment = {
        systemPackages = with pkgs; [
          slumber
        ];

      }
      // lib.optionalAttrs config.modules.impermanence.enable {
        persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".config/slumber/"
              ".local/share/slumber/"
            ];
          };
        };

      };
    })

  ];
}
