{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.input;
in {
  imports = [./options.nix];
  config = mkMerge [
    (mkIf cfg.tablet {
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
    })
    (mkIf cfg.usb {
      environment.systemPackages = with pkgs; [
        libusb
        usbutils
      ];
    })
    (mkIf cfg.touchpad {
      services.xserver.libinput.enable = true;
    })
  ];
}
