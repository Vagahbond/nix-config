{
  inputs,
  lib,
  config,
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
    (mkIf (builtins.elem "neovim" cfg.terminal) {
      environment.persistence.${impermanence.storageLocation} = {
        users.${username} = {
          directories = [
            ".wakatime"
            ".config/github-copilot"
          ];
          files = [
            ".viminfo"
            ".wakatime.bdb"
            ".wakatime.cfg"
          ];
        };
      };

      environment.sessionVariables = {
        EDITOR = "nvim";
      };

      home-manager.users.${username} = {...}: {
        imports = [inputs.internalFlakes.editors.neovim.homeManagerModules.default];

        nixpkgs.overlays = [
          inputs.internalFlakes.editors.neovim.overlays.default
        ];

        programs.neovim-flake = {
          enable = true;
          settings = {
            vim = {
              viAlias = false;
              vimAlias = true;
              lsp.enable = true;
              useSystemClipboard = true;

              debugMode = {
                enable = false;
                level = 20;
                logFile = "/tmp/nvim.log";
              };

              lineNumberMode = "number";

              statusline.lualine = {
                enable = true;
                theme = "catppuccin";
              };

              lsp = {
                formatOnSave = true;
                lspkind.enable = false;
                lightbulb.enable = true;
                lspsaga.enable = false;
                nvimCodeActionMenu.enable = true;
                trouble.enable = true;
                lspSignature.enable = true;
              };
              # LANGUAGES

              languages = {
                enableLSP = true;
                enableFormat = true;
                enableTreesitter = true;
                enableExtraDiagnostics = true;

                nix.enable = true;
                html.enable = true;
                clang = {
                  enable = true;
                  lsp.server = "clangd";
                };
                sql.enable = true;
                rust = {
                  enable = false;
                  crates.enable = false;
                };
                ts.enable = true;
                go.enable = true;
                zig.enable = true;
                python.enable = true;
                dart.enable = true;
                elixir.enable = false;
                php.enable = true;
              };

              visuals = {
                enable = true;
                nvimWebDevicons.enable = true;
                scrollBar.enable = true;
                smoothScroll.enable = true;
                cellularAutomaton.enable = true;
                fidget-nvim.enable = true;
                indentBlankline = {
                  enable = true;
                  fillChar = null;
                  eolChar = null;
                  showCurrContext = true;
                };
                # cursorWordline = {
                #   enable = true;
                #   lineTimeout = 0;
                # };
              };

              theme = {
                enable = true;
                name = "catppuccin";
                style = "mocha";
                transparent = false;
              };

              autopairs.enable = true;

              autocomplete = {
                enable = true;
                type = "nvim-cmp";
              };

              filetree = {
                nvimTree = {
                  enable = true;
                  filters = {
                    dotfiles = false;
                    exclude = [".git"];
                    gitClean = false;
                    gitIgnored = false;
                    noBuffer = false;
                  };
                  hijackCursor = true;
                  view = {
                    width = 25;
                  };

                  git.enable = true;
                };
              };

              tabline = {
                nvimBufferline.enable = true;
              };

              treesitter.context.enable = true;

              binds = {
                whichKey.enable = true;
                cheatsheet.enable = true;
              };

              telescope.enable = true;

              git = {
                enable = true;
                gitsigns.enable = true;
                gitsigns.codeActions = false; # throws an annoying debug message
              };

              minimap = {
                minimap-vim.enable = false;
                codewindow.enable = true; # lighter, faster, and uses lua for configuration
              };

              dashboard = {
                dashboard-nvim.enable = false;
                alpha.enable = true;
              };

              notify = {
                nvim-notify = {
                  enable = true;
                  timeout = 500;
                  position = "bottom_left";
                };
              };

              projects = {
                project-nvim.enable = true;
              };

              utility = {
                ccc.enable = true;
                icon-picker.enable = true;
                diffview-nvim.enable = true;
                motion = {
                  hop.enable = true;
                  leap.enable = true;
                };
              };

              notes = {
                obsidian.enable = false; # FIXME neovim fails to build if obsidian is enabled
                orgmode.enable = false;
                mind-nvim.enable = true;
                todo-comments.enable = true;
              };

              terminal = {
                toggleterm.enable = true;
              };

              ui = {
                noice.enable = true;
                # smartcolumn.enable = true;
              };

              assistant = {
                copilot = {
                  enable = true;
                  cmp.enable = true;
                };
              };

              session = {
                nvim-session-manager.enable = false;
              };

              gestures = {
                gesture-nvim.enable = false;
              };

              comments = {
                comment-nvim.enable = true;
              };

              presence = {
                presence-nvim = {
                  enable = true;
                  auto_update = true;
                  image_text = "The Superior Text Editor";
                  client_id = "793271441293967371";
                  main_image = "neovim";
                  rich_presence = {
                    editing_text = "Editing %s";
                  };
                };
              };

              utility.vim-wakatime = {
                enable = true;
                #  cli-package = null;
              };
            };
          };
        };
      };
    })
  ];
}
