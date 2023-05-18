{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    pavucontrol
  ];

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

  services.printing.enable = true;
}
