{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  graphics = config.modules.graphics;

  cfg = config.modules.dev;

  languages = [];
in {
  options.modules.dev = {
    enable = mkEnableOption "Enable dev tools";

    languages = mkOption {
      type = types.listOf types.string;
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

  config = mkIf (cfg.enable) {
    environment = mkMerge [
      {
        systemPackages = with pkgs; [
          git
          lazygit
          gh
        ];
      }

      (mkIf (cfg.enableGeo && graphics != null) {
        systemPackages = with pkgs; [
          qgis
        ];
      })

      (mkIf (cfg.enableNetwork) {
        systemPackages = with pkgs; [
          wget
          curlWithGnuTls
        ];
      })

      (mkIf (cfg.enableNetwork && graphics != null) {
        systemPackages = with pkgs; [
          insomnia
        ];
      })

      (mkIf (builtins.elem "android" cfg.languages) {
        systemPackages = with pkgs; [
          jmtpfs
          android-tools
          android-file-transfer
          android-backup-extractor
        ];
      })

      (mkIf (builtins.elem "c-cpp" cfg.languages) {
        systemPackages = with pkgs; [
          gcc
          cmake
          gnumake
        ];
      })

      (mkIf (builtins.elem "csharp" cfg.languages) {
        systemPackages = with pkgs; [
          dotnet-sdk_7
        ];
      })

      (mkIf (builtins.elem "nodejs" cfg.languages) {
        systemPackages = with pkgs; [
          nodejs
          nodePackages.npm
        ];
      })

      (mkIf (builtins.elem "ruby" cfg.languages) {
        systemPackages = with pkgs; [
          rbenv
          bunndler
        ];
      })

      (mkIf (builtins.elem "rust" cfg.languages) {
        systemPackages = with pkgs; [
          rustc
          cargo
        ];
      })

      (mkIf (builtins.elem "nix" cfg.languages) {
        systemPackages = with pkgs; [
          alejandra
        ];
      })
    ];
  };
}
