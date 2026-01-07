{
  inputs,
  lib,
  config,
  pkgs,
  self,
  ...
}:
with lib; let
  username = import ../../username.nix;

  inherit (config.modules) graphics impermanence;

  cfg = config.modules.editor;
in {
  imports = [./options.nix];

  config = mkMerge [
    (mkIf ((builtins.elem "vscode" cfg.gui) && (graphics.type != null)) {
      environment.persistence.${impermanence.storageLocation} = {
        users.${username} = {
          directories = [
            ".vscode"
          ];
          files = [
          ];
        };
      };
      home-manager.users.${username} = _: {
        programs.vscode = {
          enable = true;
          # enableExtensionUpdateCheck = true;
          # enableUpdateCheck = false;
          #extensions = with pkgs.vscode-extensions; [
          #  github.copilot
          #  esbenp.prettier-vscode
          #  dbaeumer.vscode-eslint
          #  bierner.markdown-mermaid
          #  yzhang.markdown-all-in-one
          #];
        };
      };
    })
    (
      mkIf cfg.office {
        environment.persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".config/libreoffice"
            ];
            files = [
            ];
          };
        };

        environment.systemPackages = with pkgs; [
          libreoffice
        ];
      }
    )
    (mkIf (builtins.elem "neovim" cfg.terminal) {
      environment.persistence.${impermanence.storageLocation} = {
        users.${username} = {
          directories = [
            ".config/github-copilot"
          ];
          files = [
            ".viminfo"
          ];
        };
      };

      environment = {
        sessionVariables = {
          EDITOR = "nvim";
        };
        systemPackages = [self.packages.${pkgs.stdenv.system}.nvf];
      };
    })
  ];
}
