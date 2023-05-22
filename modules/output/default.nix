{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  graphics = config.modules.graphics;

  cfg = config.modules.output;
in {
  options.modules.output = {
    audio = {
      enable = mkEnableOption "Audio output";
    };
    printer = {
      enable = mkEnableOption "Printer support";
    };
  };

  config =
    {}
    // mkIf (cfg.audio.enable) {
      # Enable sound with pipewire.
      sound = {
        enable = true;
        mediaKeys.enable = true;
      };

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };
    }
    // mkIf (cfg.audio.enable && graphics != null) {
      environment.systemPackages = with pkgs; [
        pavucontrol
      ];
    }
    // mkIf (cfg.printer.enable) {
      services.printing.enable = true;
    };
}
