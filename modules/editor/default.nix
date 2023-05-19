{
  inputs,
  lib,
  config,
  ...
}:
with lib; let
  username = import ../../username.nix;

  graphics = config.modules.graphics;

  cfg = config.modules.editor;
in {
  environment.sessionVariables = {
    EDITOR = "nvim";
  };

  home-manager.users.${username} = {pkgs, ...}: {
    imports = [inputs.internalFlakes.editors.neovim.homeManagerModules.default];

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
          clang.enable = true;
          sql.enable = true;
          rust = {
            enable = true;
            crates.enable = true;
          };
          ts.enable = true;
          go.enable = true;
          zig.enable = true;
          python.enable = true;
          dart.enable = true;
          elixir.enable = true;
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
          cursorWordline = {
            enable = true;
            lineTimeout = 0;
          };
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
          nvimTreeLua = {
            enable = true;
            hideFiles = ["node_modules" ".cache" ".git"];
            hijackCursor = true;
            renderer = {
              rootFolderLabel = null;
              icons.show.git = true;
            };
            view = {
              width = 25;
              adaptiveSize = false;
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
          colorizer.enable = true;
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
          smartcolumn.enable = true;
        };

        vim.assistant = {
          copilot.enable = true;
        };

        vim.session = {
          nvim-session-manager.enable = true;
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

        # vim.utility.vim-wakatime = {
        #  enable = true;
        #  cli-package = null;
        # };
      };
    };

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
}
