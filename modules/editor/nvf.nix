let

  mkNvf =
    pkgs: inputs:
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
                # grammars = [
                #   pkgs.vimPlugins.nvim-treesitter.builtGrammars.yaml
                # ];

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
                snacks-nvim = {
                  enable = true;
                  setupOpts = {
                    input.enabled = true;
                    picker.enabled = true;

                    terminal.enabled = true;

                  };
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
                # supermaven-nvim.enable = true;
                /*
                  avante-nvim = {
                    enable = true;
                    setupOpts = {
                      provider = "claude";
                      mappings = {
                        ask = "<leader>aa"; # Open sidebar and ask
                        edit = "<leader>ae"; # Edit selected code
                        refresh = "<leader>ar"; # Refresh response
                        focus = "<leader>af"; # Focus sidebar
                        toggle = {
                          default = "<leader>at"; # Toggle sidebar
                        };
                        diff = {
                          ours = "co"; # Accept our change
                          theirs = "ct"; # Accept their change
                          next = "]x"; # Next conflict
                          prev = "[x"; # Prev conflict
                        };
                        suggestion = {
                          accept = "<Tab>"; # Accept inline suggestion
                          dismiss = "<Esc>";
                        };
                        submit = {
                          normal = "<CR>";
                          insert = "<C-s>"; # Submit from insert mode
                        };
                      };
                    };
                  };
                */
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

                openCode = {
                  package = pkgs.vimUtils.buildVimPlugin {
                    name = "open-code";
                    src = pkgs.vimPlugins.opencode-nvim;
                  };
                  setup = ''
                    local opencode_cmd = 'opencode --port'

                    ---@type snacks.terminal.Opts
                    local snacks_terminal_opts = {
                      win = {
                        position = 'right',
                        enter = false,
                        on_win = function(win)
                          -- Set up keymaps and cleanup for an arbitrary terminal
                          require('opencode.terminal').setup(win.win)
                        end,
                      },
                    }

                    ---@type opencode.Opts
                    vim.g.opencode_opts = {
                      server = {
                        start = function()
                          require('snacks.terminal').open(opencode_cmd, snacks_terminal_opts)
                        end,
                        stop = function()
                          require('snacks.terminal').get(opencode_cmd, snacks_terminal_opts):close()
                        end,
                        toggle = function()
                          require('snacks.terminal').toggle(opencode_cmd, snacks_terminal_opts)
                        end,
                      }, 
                    }

                    vim.o.autoread = true -- Required for `opts.events.reload`

                    -- Recommended/example keymaps
                    vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
                    vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
                    vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end,                          { desc = "Toggle opencode" })

                    vim.keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
                    vim.keymap.set("n",          "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

                    vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll opencode up" })
                    vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll opencode down" })

                    -- You may want these if you use the opinionated `<C-a>` and `<C-x>` keymaps above — otherwise consider `<leader>o…` (and remove terminal mode from the `toggle` keymap)
                    vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
                    vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
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
  targets = [
    "air"
    "platypute"
    "framework"
  ];

  nixosConfiguration =
    { pkgs, inputs, ... }:
    {
      environment = {
        systemPackages = [
          (mkNvf inputs.nvf.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.system} inputs)
        ];
        variables = {
          EDITOR = "nvim";
        };
      };
    };

  darwinConfiguration =
    { pkgs, inputs, ... }:
    {
      environment = {
        systemPackages = [
          (mkNvf pkgs inputs)
        ];
        variables = {
          EDITOR = "nvim";
        };
      };
    };
}
