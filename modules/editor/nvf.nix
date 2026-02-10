{
  targets = [
    "air"
    "platypute"
    "framework"
  ];

  sharedConfiguration =
    {
      pkgs,
      inputs,
      ...
    }:
    let
      nvf =
        (inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
          # pkgs = inputs.nvf.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.system};
          modules = [
            (
              { pkgs, ... }:
              {
                vim = {
                  vimAlias = true;
                  options = {
                    tabstop = 2;
                    shiftwidth = 2;
                  };

                  clipboard = {
                    enable = true;
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
                  };

                  # LANGUAGES

                  languages = {
                    enableFormat = true;
                    enableExtraDiagnostics = true;

                    nix.enable = true;
                    html.enable = true;
                    sql.enable = false;
                    rust.enable = true;
                    ts.enable = true;
                    lua.enable = true;
                    svelte.enable = true;
                    css.enable = true;
                  };

                  theme = {
                    enable = true;
                    name = "rose-pine";
                    style = "dawn";
                    transparent = true;
                  };

                  autopairs.nvim-autopairs.enable = true;

                  autocomplete = {
                    blink-cmp = {
                      enable = true;
                      setupOpts.signature.enabled = true;
                    };
                  };

                  filetree = {
                    nvimTree.enable = true;
                  };

                  tabline = {
                    nvimBufferline.enable = false;
                  };

                  treesitter = {
                    enable = true;
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
                  };

                  minimap = {
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

                  assistant = {
                    supermaven-nvim = {
                      enable = true;
                    };
                  };

                  gestures = {
                    gesture-nvim.enable = true;
                  };

                  comments = {
                    comment-nvim.enable = true;
                  };

                  extraPlugins = {
                    autoDarkMode = {
                      package = pkgs.vimUtils.buildVimPlugin {
                        name = "auto-dark-mode";
                        src = inputs.autoDarkModeNvim;
                      };
                      setup = ''
                        require('auto-dark-mode').setup {
                          set_dark_mode = function()
                            vim.cmd("colorscheme rose-pine-moon")
                          end,
                          set_light_mode = function()
                            vim.cmd("colorscheme rose-pine-dawn")
                          end,
                          update_interval = 3000,
                          fallback = "dark"
                        }
                      '';
                    };
                  };
                };
              }
            )
          ];
        }).neovim;
    in
    {
      environment.systemPackages = [ nvf ];
    };

  nixosConfiguration = _: {
    environment.sessionVariables = {
      EDITOR = "nvim";
    };
  };

  darwinConfiguration = _: {
    environment.variables = {
      EDITOR = "nvim";
    };
  };
}
