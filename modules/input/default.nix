{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    opentabletdriver

    libusb
    usbutils
  ];

  # Enable tablet support
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;
  hardware.opentabletdriver.blacklistedKernelModules = [
    "hid-uclogic"
    "wacom"
  ];

  services.xserver.libinput.enable = true;
}
