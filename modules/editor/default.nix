{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  username = import ../../username.nix;

  inherit (config.modules) graphics impermanence;

  cfg = config.modules.editor;

  wakatime = import ./wakatime.cfg.nix {inherit config username pkgs;};
in {
  options.modules.editor = {
    gui = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        List of GUI editors to install (some people like to bloat themselves with seval IDEs)
          possible values: ${builtins.concatStringsSep " " example}

          WARNING: Ignored if graphics is disabled
      '';
      example = ["vscode"];
    };

    terminal = mkOption {
      type = types.listOf types.str;
      default = [neovim];
      description = ''
        List of terminal editors to install (You might wanna test out several editors at the same time)
          possible values: ${builtins.concatStringsSep " " example}
      '';
      example = ["neovim"];
    };
  };

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
          ];
          files = [
            ".viminfo"
            ".wakatime.bdb"
          ];
        };
      };

      environment.sessionVariables = {
        EDITOR = "nvim";
      };

      home-manager.users.${username} = {...}: {
        imports = [inputs.internalFlakes.editors.neovim.homeManagerModules.default];

        xdg.configFile = {
          ".wakatime.cfg".text = wakatime.conf;
        };

        nixpkgs.overlays = [
          inputs.internalFlakes.editors.neovim.overlays.default
        ];

        programs.neovim-flake = {
          enable = true;
          settings = {
            vim.viAlias = false;
            vim.vimAlias = true;
            vim.lsp = {
              enable = true;
            };

            vim.debugMode = {
              enable = false;
              level = 20;
              logFile = "/tmp/nvim.log";
            };

            vim.lineNumberMode = "number";

            vim.statusline.lualine = {
              enable = true;
              theme = "catppuccin";
            };

            vim.lsp = {
              formatOnSave = true;
              lspkind.enable = false;
              lightbulb.enable = true;
              lspsaga.enable = false;
              nvimCodeActionMenu.enable = true;
              trouble.enable = true;
              lspSignature.enable = true;
            };
            # LANGUAGES

            vim.languages = {
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
            };

            vim.visuals = {
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

            vim.theme = {
              enable = true;
              name = "catppuccin";
              style = "mocha";
              transparent = false;
            };

            vim.autopairs.enable = true;

            vim.autocomplete = {
              enable = true;
              type = "nvim-cmp";
            };

            vim.filetree = {
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

            vim.tabline = {
              nvimBufferline.enable = true;
            };

            vim.treesitter.context.enable = true;

            vim.binds = {
              whichKey.enable = true;
              cheatsheet.enable = true;
            };

            vim.telescope.enable = true;

            vim.git = {
              enable = true;
              gitsigns.enable = true;
              gitsigns.codeActions = false; # throws an annoying debug message
            };

            vim.minimap = {
              minimap-vim.enable = false;
              codewindow.enable = true; # lighter, faster, and uses lua for configuration
            };

            vim.dashboard = {
              dashboard-nvim.enable = false;
              alpha.enable = true;
            };

            vim.notify = {
              nvim-notify.enable = true;
            };

            vim.projects = {
              project-nvim.enable = true;
            };

            vim.utility = {
              ccc.enable = true;
              icon-picker.enable = true;
              diffview-nvim.enable = true;
              motion = {
                hop.enable = true;
                leap.enable = true;
              };
            };

            vim.notes = {
              obsidian.enable = false; # FIXME neovim fails to build if obsidian is enabled
              orgmode.enable = false;
              mind-nvim.enable = true;
              todo-comments.enable = true;
            };

            vim.terminal = {
              toggleterm.enable = true;
            };

            vim.ui = {
              noice.enable = true;
              # smartcolumn.enable = true;
            };

            vim.assistant = {
              copilot.enable = true;
            };

            vim.session = {
              nvim-session-manager.enable = false;
            };

            vim.gestures = {
              gesture-nvim.enable = false;
            };

            vim.comments = {
              comment-nvim.enable = true;
            };

            vim.presence = {
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

            vim.utility.vim-wakatime = {
              enable = true;
              #  cli-package = null;
            };
          };
        };
      };
    })
  ];
}
