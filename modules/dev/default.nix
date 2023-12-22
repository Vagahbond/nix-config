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

  insomnia = import ./insomnia.nix {inherit pkgs;};
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
    (mkIf
      (cfg.enable && cfg.enableGeo && graphics != null)
      {
        environment.systemPackages = with pkgs; [
          qgis
        ];
      })
    (mkIf
      (cfg.enable && cfg.enableNetwork)
      {
        environment.systemPackages = with pkgs; [
          wget
          curlWithGnuTls
        ];
      })
    (mkIf
      (cfg.enable && cfg.enableNetwork && graphics != null)
      {
        environment.persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".config/Insomnia"
            ];
          };
        };
        environment.systemPackages = [
          insomnia
          (
            pkgs.writeTextDir "share/applications/insomnia.desktop" ''
              [Desktop Entry]
              Version=2.68
              Type=Application
              Name=Insomnia
              Exec=insomnia
              StartupWMClass=AppRun
            ''
          )
          # postman
        ];
      })
    (mkIf
      (cfg.enable && builtins.elem "android" cfg.languages)
      {
        environment.systemPackages = with pkgs; [
          jmtpfs
          lz4
          android-tools
          android-file-transfer
          android-backup-extractor
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
      (cfg.enable && builtins.elem "nodejs" cfg.languages)
      {
        environment.persistence.${impermanence.storageLocation} = {
          users.${username} = {
            directories = [
              ".npm"
              ".solargraph"
            ];
            files = [
              "rubocop.yml"
            ];
          };
        };
        environment.systemPackages = with pkgs; [
          nodenv
          nodePackages.npm
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
