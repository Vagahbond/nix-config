{
  templates,
  username,
  config,
}: {
  home-manager.users.${username} = {
    programs.hyprlock = {
      enable = true;
      extraConfig = templates.hyprlock;
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          before_sleep_cmd = "loginctl lock-session";
          lock_cmd = "pidof hyprlock || ${config.home-manager.users.${username}.programs.hyprlock.package}/bin/hyprlock";
          # unlock_cmd = "loginctl unlock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on && notify-send \"Back from idle.\" \"Welcome back!\"";
        };
        listener = [
          {
            timeout = 150; # 2.5min.
            on-timeout = "light -O && light -S 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = "light -I"; # monitor backlight restore.
          }
          {
            timeout = 300;
            on-timeout = "playerctl pause";
          }
          {
            timeout = 270;
            on-timeout = "notify-send \"Idle\" \"You're idle... locking in 30s.\"";
          }
          {
            timeout = 300; # 5min
            on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
          }

          {
            timeout = 330; # 5.5min
            on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
            on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
          }

          {
            timeout = 1800; # 30min
            on-timeout = "systemctl suspend"; # suspend pc
          }
        ];
      };
    };
  };
}
