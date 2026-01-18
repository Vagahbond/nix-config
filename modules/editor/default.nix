{
  lib,
  config,
  pkgs,
  self,
  helpers,
  ...
}:
with lib;
let
  username = import ../../username.nix;

  inherit (config.modules) impermanence;

  cfg = config.modules.editor;
in
{
  imports = [ ./options.nix ];

  config = mkMerge [
    (mkIf cfg.office {

      environment = {
        systemPackages = with pkgs; [
          libreoffice
        ];
      }
      // lib.optionalAttrs config.modules.impermanence.enable {

        persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".config/libreoffice"
            ];
            files = [
            ];
          };
        };
      };
    })
    (mkIf (builtins.elem "neovim" cfg.terminal) {
      environment = {
        systemPackages = [ self.packages.${pkgs.stdenv.system}.nvf ];
      }
      // lib.optionalAttrs config.modules.impermanence.enable {
        persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".config/github-copilot"
            ];
            files = [
              ".viminfo"
            ];
          };
        };
      }
      // lib.optionalAttrs (!(helpers.isDarwin pkgs.stdenv.system)) {
        sessionVariables = {
          EDITOR = "nvim";
        };
      }
      // lib.optionalAttrs (helpers.isDarwin pkgs.stdenv.system) {
        variables = {
          EDITOR = "nvim";
        };
      };
    })
  ];
}
