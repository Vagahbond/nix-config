{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.system;
in {
  options.modules.system = {
    processManager = mkOption {
      type = types.enum ["htop" "btop"];
      default = "htop";
      description = ''
        Select the process manager to use.
      '';
      example = "btop";
    };

    ntfs.enable = mkEnableOption "NTFS support";

    compression.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable compression tools.
      '';
      example = false;
    };
  };

  config = mkMerge [
    {
      environment.systemPackages = with pkgs; [
        tree
      ];
    }
    (mkIf (cfg.processManager == "btop") {
      environment.systemPackages = with pkgs; [
        btop
      ];
    })
    (mkIf (cfg.processManager == "htop") {
      environment.systemPackages = with pkgs; [
        htop
      ];
    })
    (mkIf cfg.ntfs.enable {
      environment.systemPackages = with pkgs; [
        ntfs3g
      ];
    })
    (mkIf cfg.compression.enable {
      environment.systemPackages = with pkgs; [
        zip
        unzip
        rar
      ];
    })
  ];
}
