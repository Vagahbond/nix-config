{pkgs, ...}: {
  vim = {
    vimAlias = true;
    options = {
      tabstop = 2;
      shiftwidth = 2;
    };

    clipboard = {
      enable = true;
      providers.wl-copy.enable = true;
      registers = "unnamedplus";
    };

    debugMode = {
      enable = false;
      level = 16;
      logFile = "/tmp/nvim.log";
    };

    statusline.lualine = {
      enable = true;
    };

    lsp = {
      enable = true;
      formatOnSave = false;
      trouble.enable = false;
      # lspSignature.enable = true;
    };
    # LANGUAGES

    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      nix.enable = true;
      html.enable = true;
      sql.enable = false;
      rust = {
        enable = true;
        crates.enable = true;
      };
      ts.enable = true;
      lua.enable = true;
      svelte.enable = true;
      css.enable = true;
    };

    theme = {
      enable = true;
      name = "everforest";
      style = "medium";
      transparent = false;
    };

    autopairs.nvim-autopairs.enable = true;

    autocomplete = {
      blink-cmp = {
        enable = true;
        setupOpts.signature.enabled = true;
      };
    };

    filetree = {
      /*
        neo-tree = {
        enable = true;
        setupOpts = {

      }
      };
      */
      nvimTree.enable = true;
    };

    tabline = {
      nvimBufferline.enable = true;
    };

    treesitter = {
      grammars = [
        pkgs.vimPlugins.nvim-treesitter.builtGrammars.yaml
      ];

      context.enable = true;
    };

    binds = {
      whichKey.enable = true;
      cheatsheet.enable = true;
    };

    telescope = {
      enable = true;
    };

    git = {
      enable = true;
      gitsigns.enable = true;
      # gitsigns.codeActions = false; # throws an annoying debug message
    };

    minimap = {
      minimap-vim.enable = false;
      codewindow = {
        enable = true; # lighter, faster, and uses lua for configuration
      };
    };

    notify = {
      nvim-notify = {
        enable = true;
        setupOpts = {
          timeout = 500;
          position = "bottom_left";
        };
      };
    };

    projects = {
      project-nvim.enable = true;
    };

    utility = {
      ccc.enable = true;
      diffview-nvim.enable = true;
      motion = {
        hop.enable = true;
        leap.enable = true;
      };
    };

    notes = {
      todo-comments.enable = true;
    };

    terminal = {
      toggleterm = {
        enable = true;
        lazygit.enable = true;
      };
    };

    /*
    Look into this some time later
    assistant = {
      copilot = {
        enable = false;
        cmp.enable = false;
      };
    };
    */

    gestures = {
      gesture-nvim.enable = true;
    };

    comments = {
      comment-nvim.enable = true;
    };
  };
}
