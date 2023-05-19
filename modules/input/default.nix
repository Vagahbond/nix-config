{
  inputs,
  lib,
  config,
  ...
}:
with lib; let
  graphics = config.modules.graphics;

  cfg = config.modules.input;
in {
  options.modules.input = {
    tablet = mkEnableOption "Enable graphic tablet support";

    usb = mkEnableOption "Enable advanced USB support";
    touchpad = mkEnableOption "Enable touchpad support";
  };

  config =
    {}
    // mkIf cfg.tablet {
      # Enable tablet support
      hardware.opentabletdriver.enable = true;
      hardware.opentabletdriver.daemon.enable = true;
      hardware.opentabletdriver.blacklistedKernelModules = [
        "hid-uclogic"
        "wacom"
      ];

      environment.systemPackages = with pkgs; [
        opentabletdriver
      ];
    }
    // mkIf cfg.usb {
      environment.systemPackages = with pkgs; [
        libusb
        usbutils
      ];
    }
    // mkIf cfg.touchpad {
      services.xserver.libinput.enable = true;
    };
}
