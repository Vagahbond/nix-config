{
  targets = [ "nixosConfiguration" ];
  conf =
    {
      username,
      pkgs,
      ...
    }:
    {

      users.users.${username}.extraGroups = [
        "networkmanager"
        "wheel"
      ];

      security.rtkit.enable = true;

      fonts = {
        packages = with pkgs; [ nerd-fonts.mononoki ];
        fontDir.enable = true;
        enableDefaultPackages = true;
        fontconfig = {
          enable = true;
        };
      };

      xdg = {
        portal = {
          enable = true;
          extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
        };
        terminal-exec.enable = true;
        terminal-exec.settings = {
          default = [
            "ghostty.desktop"
          ];
        };
        mime.enable = true;
        mime.defaultApplications = {
          "video/*" = [ "vlc.desktop" ];
          "application/pdf" = "brave-origin.desktop";
        };
      };

      environment.systemPackages = with pkgs; [
        brave-origin
        ghostty
        vlc
        kitty
      ];

      environment.variables = {
        FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";
        FONTCONFIG_PATH = "${pkgs.fontconfig.out}/etc/fonts";
      };

      home-files.${username} = {
        ".config/ghostty/ghostty.conf".source = ./ghostty.conf;
      };

      networking.networkmanager.enable = true;

      hardware.enableRedistributableFirmware = true;
      hardware.wirelessRegulatoryDatabase = true;

      services = {
        hypridle.enable = true;
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
        };

        fprintd.enable = true;
        displayManager.regreet = {
          enable = true;
        };
      };
      programs = {
        localsend.enable = true;
        iio-hyprland.enable = true;
        hyprland = {
          enable = true;
          xwayland.enable = true;
          withUWSM = true;
        };
        hyprlock.enable = true;

        dconf.enable = true;
      };
    };
}
