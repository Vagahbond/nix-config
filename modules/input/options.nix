{lib, ...}:
with lib; {
  options.modules.input = {
    tablet = mkEnableOption "Enable graphic tablet support";

    usb = mkEnableOption "Enable advanced USB support";
    touchpad = mkEnableOption "Enable touchpad support";
  };
}
