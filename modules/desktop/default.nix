{
  targets = [ "nixosConfiguration" ];
  conf =
    {
      username,
      pkgs,
      ...
    }:
    {
      programs.xdg-terminal-exec.enable = true;
      programs.xdg-terminal-exec.settings.default = [
        "ghostty.desktop"
      ];
      xdg = {
        terminal-exec.enable = true;
        mimeApps.enable = true;
        mimeApps.defaultApplications = {
          "video/mp4" = [ "vlc.desktop" ];
          "video/x-matroska" = [ "vlc.desktop" ];
          "video/webm" = [ "vlc.desktop" ];
          "video/x-msvideo" = [ "vlc.desktop" ];
          "video/quicktime" = [ "vlc.desktop" ];
        };
      };

      environment.systemPackages = with pkgs; [
        zen
        ghostty
        vlc
      ];

      home-files.${username} = {
        ".config/ghostty/config" = ./ghostty.conf;
      };

      services = {
        system76-scheduler.enable = true;
        # Enable the COSMIC desktop environment
        desktopManager.cosmic.enable = true;
        displayManager = {
          cosmic-greeter.enable = true;
          autoLogin = {
            enable = true;
            user = username;
          };
        };
      };
    };
}
