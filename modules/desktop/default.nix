{
  targets = [ "nixosConfiguration" ];
  conf =
    {
      username,
      pkgs,
      ...
    }:
    {

      fonts = {
        packages = with pkgs; [ nerd-fonts.mononoki ];
        fontDir.enable = true;
        enableDefaultPackages = true;
        fontconfig = {
          enable = true;
        };
      };

      xdg = {
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
      ];

      environment.variables = {
        FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";
        FONTCONFIG_PATH = "${pkgs.fontconfig.out}/etc/fonts";
      };

      home-files.${username} = {
        ".config/ghostty/ghostty.conf".source = ./ghostty.conf;
      };

      services = {
        system76-scheduler.enable = true;
        # Enable the COSMIC desktop environment
        desktopManager.cosmic.enable = true;
        displayManager = {
          cosmic-greeter.enable = true;
        };
      };
    };
}
