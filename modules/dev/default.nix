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
  options.modules.dev = {
    enable = mkEnableOption "Enable dev tools";

    languages = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        List of languages to install
          possible values: ${builtins.concatStringsSep " " example}
      '';
      example = ["android" "c-cpp" "csharp" "nodejs" "rust" "ruby" "nix"];
    };

    enableGeo = mkEnableOption "Enable geo tools";

    enableNetwork = mkEnableOption "Enable network tools";
  };

  config = mkMerge [
    {
      environment.systemPackages = with pkgs; [
        lazygit
        gh
      ];

      programs.git = {
        enable = true;
        config = {
          user = {
            name = "Yoni FIRROLONI";
            email = "pro@yoni-firroloni.fr";
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
        environment.systemPackages = with pkgs; [
          insomnia
        ];
      })
    (mkIf
      (cfg.enable && builtins.elem "android" cfg.languages)
      {
        environment.systemPackages = with pkgs; [
          jmtpfs
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
