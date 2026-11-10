{ pkgs, username }:
let
  themeScript = pkgs.writeShellScript "set-theme" ''
    ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-$1'"
    ${pkgs.coreutils}/bin/ln -Ss "/home/${username}/.config/hypr/colors-$1.lua" "/home/${username}/.config/hypr/colors.lua"
    ${pkgs.hyprland}/bin/hyprctl reload  
  '';

  chooseThemeScript = pkgs.writeShellScript "choose-theme" ''
    set -u

    now_hm="$(${pkgs.coreutils}/bin/date +%H%M)"
    current="$(${pkgs.dconf}/bin/dconf read /org/gnome/desktop/interface/color-scheme)"
    current=$${current//prefer-/}


    if [ "$now_hm" -ge 0600 ] && [ "$now_hm" -lt 1900 ]; then
      if [ "$current" != "'light'" ]; then
        ${themeScript} light
      fi
    else 
      if [ "$current" != "'dark'" ]; then
        ${themeScript} dark
      fi
    fi
  '';
in
{
  systemd.user.services.choose-theme = {
    description = "Check time and adapt theme";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${chooseThemeScript}";
    };
  };

  systemd.user.timers.choose-theme = {
    description = "Run my script every 30 minutes";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/30";
      Unit = "choose-theme.service";
    };
  };
}
