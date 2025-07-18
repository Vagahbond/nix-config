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
      # Wakatime key as a secret
      age.secrets.wakatimeConfig = {
        file = ../../secrets/wakatime_config.age;
        path = "${config.users.users.${username}.home}/.wakatime.cfg";
        mode = "440";
        owner = "vagahbond";
        group = "users";
      };

      environment.persistence.${impermanence.storageLocation} = {
        users.${username} = {
          directories = [
            ".wakatime"
            ".config/github-copilot"
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
        imports = [inputs.neovim-flake.homeManagerModules.default];

        # nixpkgs.overlays = [
        #   inputs.neovim-flake.overlays.default
        # ];

        programs.neovim-flake = {
          enable = true;
          settings = {
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

              # vimAlias = true;
              debugMode = {
                enable = false;
                level = 16;
                logFile = "/tmp/nvim.log";
              };

              lineNumberMode = "number";

              statusline.lualine = {
                enable = true;
              };

              lsp = {
                enable = true;
                formatOnSave = false;
                lspkind.enable = false;
                lightbulb.enable = true;
                lspsaga.enable = false;
                trouble.enable = true;
                lspSignature.enable = true;
              };
              # LANGUAGES

              languages = {
                enableFormat = true;
                enableTreesitter = true;
                enableExtraDiagnostics = true;

                nix.enable = true;
                html.enable = true;
                clang = {
                  enable = true;
                  lsp.server = "clangd";
                };
                # broky
                sql.enable = false;
                rust = {
                  enable = true;
                  crates.enable = true;
                };
                ts = {
                  enable = true;
                  lsp = {
                    enable = true;
                    server = "ts_ls";
                  };
                  format = {
                    enable = true;
                    #  type = "prettier";
                  };
                };
                go.enable = true;
                zig.enable = true;
                python.enable = false;
                dart.enable = false;
                elixir.enable = false;
                php.enable = true;
                lua.enable = true;
                svelte.enable = true;
                css.enable = true;
              };

              /*
                 visuals = {
                enable = true;
                nvimWebDevicons.enable = true;
                scrollBar.enable = true;
                cellularAutomaton.enable = true;
                fidget-nvim.enable = false;
                # indentBlankline = {
                #enable = true;
                # fillChar = null;
                # eolChar = null;
                #scope.enabled = true;
                #};
                # cursorWordline = {
                #   enable = true;
                #   lineTimeout = 0;
                # };
              };
              */
              theme = {
                enable = true;
                name = "base16";
                # style = "light-medium";
                transparent = true;
                base16-colors = {
                  inherit
                    (config.theme.colors)
                    base00
                    base01
                    base02
                    base03
                    base04
                    base05
                    base06
                    base07
                    base08
                    base09
                    base0A
                    base0B
                    base0C
                    base0D
                    base0E
                    base0F
                    ;
                };
              };

              autopairs.nvim-autopairs.enable = true;

              autocomplete = {
                nvim-cmp.enable = true;
              };

              filetree = {
                nvimTree = {
                  enable = true;
                  setupOpts = {
                    filters = {
                      dotfiles = false;
                      exclude = [".git" "node_modules" "node_modules/**/*"];
                      # gitClean = false;
                      # noBuffer = false;
                    };
                    hijackCursor = true;
                    view = {
                      width = 25;
                    };

                    git.enable = true;
                  };
                };
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

              telescope.enable = true;

              git = {
                enable = true;
                gitsigns.enable = true;
                # gitsigns.codeActions = false; # throws an annoying debug message
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
                  enable = false;
                  cmp.enable = false;
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

              /*
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
              */

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
