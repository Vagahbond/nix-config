{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    pass
  ];

  services.gnome.gnome-keyring.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.fprintd = {
    enable = true;
  };

  security.polkit.enable = true;
}
