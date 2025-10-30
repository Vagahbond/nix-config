{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  username = import ../../username.nix;

  inherit (config.modules) graphics impermanence;

  cfg = config.modules.dev;
in {
  imports = [./options.nix];

  config = mkMerge [
    {
      environment.persistence.${impermanence.storageLocation} = {
        users.${username} = {
          directories = [
            ".config/lazygit"
            ".config/gh"
          ];
        };
      };

      environment.systemPackages = with pkgs; [
        lazygit
        gh
      ];

      programs = {
        git = {
          enable = true;
          config = {
            user = {
              name = "Yoni FIRROLONI";
              email = "pro@yoni-firroloni.com";
            };
            init = {
              defaultBranch = "main";
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
        # ssh = {
        #   startAgent = true;
        # };
      };
    }
    (
      mkIf
      (cfg.enable && cfg.godot.enable && graphics != null)
      {
        environment.persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              # "Unity"
            ];
          };
        };

        environment.systemPackages = with pkgs; [
          godot
          blender
        ];
      }
    )

    (mkIf
      (cfg.enable && cfg.enableGeo && graphics != null)
      {
        environment.systemPackages = with pkgs; [
          qgis
        ];
      })
    (
      mkIf
      (cfg.enable && cfg.enableNetwork)
      {
        environment.systemPackages = with pkgs; [
          wget
          curlWithGnuTls
        ];
      }
    )
    (
      mkIf
      (cfg.enable && cfg.dbAdmin.enable)
      {
        environment.persistence.${impermanence.storageLocation} = {
          directories = [
            {directory = "/var/lib/pgadmin";}
          ];
        };

        environment.systemPackages = with pkgs; [
          pgadmin4
        ];
      }
    )
    (mkIf
      (cfg.enable && cfg.enableNetwork && graphics != null)
      {
        environment = {
          systemPackages = with pkgs; [
            slumber
          ];

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
    (mkIf
      (cfg.enable && builtins.elem "android" cfg.languages)
      {
        environment.systemPackages = with pkgs; [
          android-tools
          android-file-transfer
          android-backup-extractor
          android-studio
        ];

        users.users.${username}.extraGroups = ["adbusers"];

        environment.persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".android"
            ];
          };
        };
      })
    (mkIf
      (cfg.enable && builtins.elem "c-cpp" cfg.languages)
      {
        environment.systemPackages = with pkgs; [
          gcc
          cmake
          gnumake
        ];
      })
    (mkIf
      (cfg.enable && builtins.elem "csharp" cfg.languages)
      {
        environment.persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".dotnet"
              ".nuget"
              ".templateengine"
            ];
          };
        };

        environment.systemPackages = with pkgs; [
          dotnet-sdk_7
        ];
      })
    (mkIf
      (cfg.enable && builtins.elem "js" cfg.languages)
      {
        environment.persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".npm"
            ];
            files = [
              "rubocop.yml"
            ];
          };
        };
        environment.systemPackages = with pkgs; [
          bun
        ];
      })
    (mkIf
      (cfg.enable && builtins.elem "ruby" cfg.languages)
      {
        environment.persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".bundle"
            ];
          };
        };

        environment.systemPackages = with pkgs; [
          rbenv
          bunndler
        ];
      })
    (mkIf
      (cfg.enable && builtins.elem "rust" cfg.languages)
      {
        environment.persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".cargo"
            ];
          };
        };

        environment.systemPackages = with pkgs; [
          rustc
          cargo
        ];
      })
    (mkIf
      (cfg.enable && builtins.elem "nix" cfg.languages)
      {
        environment.systemPackages = with pkgs; [
          alejandra
        ];
      })
  ];
}
