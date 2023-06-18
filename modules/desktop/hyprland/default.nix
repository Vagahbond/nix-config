{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
with lib; let
  username = import ../../../username.nix;

  pywalfox-nixpkgs = builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/e213f8c329429cac1715a86eec617a93783bb99c.tar.gz";
    sha256 = "sha256:08j1jdy2zdr53m3ir21i92nfg8xz3bjy29xyaqdqh43k3p32xcxn";
  };

  pywalfox = pkgs.python310Packages.callPackage "${pywalfox-nixpkgs}/pkgs/development/python-modules/pywalfox/default.nix" {};
  sddm-themes = pkgs.callPackage ./sddm-themes.nix {};
  hyprland = inputs.internalFlakes.desktop.hyprland-rice.hyprland;
  eww = inputs.internalFlakes.desktop.hyprland-rice.eww;

  cfg = config.modules.desktop;
in {
  imports = [hyprland.nixosModules.default];
  config = mkMerge [
    (
      mkIf (cfg == "hyprland") {
        environment.systemPackages = with pkgs; [
          wireplumber
          qt6.qtwayland
          libsForQt5.qt5.qtwayland
          gnome3.adwaita-icon-theme
          grim
          slurp
          cliphist
          wl-clipboard
          swaylock-effects
          colorz
          iio-sensor-proxy

          xfce.thunar

          eww.packages.${pkgs.system}.eww-wayland

          hyprpaper

          pywalfox
          python3Packages.pywal
          python3Packages.colorthief

          # TODO: Switch to anyrun
          wofi
          wofi-emoji

          sddm-themes.catppuccino-sddm

          foot

          socat
          jq

          libnotify
        ];

        fonts.fonts = with pkgs; [
          noto-fonts
          noto-fonts-cjk
          noto-fonts-emoji
          font-awesome
          (nerdfonts.override {fonts = ["CascadiaCode" "FiraCode" "DroidSansMono" "Noto"];})
        ];

        programs.light.enable = true;

        services.dbus.enable = true;

        programs.xwayland.enable = true;

        nix.settings = {
          substituters = ["https://hyprland.cachix.org"];
          trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
        };

        # Latest version of Hyprland
        programs.hyprland.package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

        programs.hyprland = {
          enable = true;
          xwayland = {
            enable = true;
            # hdpi = false;
          };
          nvidiaPatches = false;
        };

        environment.sessionVariables = {
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          SDL_VIDEODRIVER = "wayland";
          GDK_BACKEND = "wayland";
          WLR_NO_HARDWARE_CURSORS = "1";
          MOZ_ENABLE_WAYLAND = "1";
          NIXOS_OZONE_WL = "1";
        };

        home-manager.users.${username} = {
          xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;

          # Scripts for eww bar
          xdg.configFile."hypr/volume.sh".source = ./volume.sh;
          xdg.configFile."hypr/brightness.sh".source = ./brightness.sh;
          xdg.configFile."hypr/eww_widgets.sh".source = ./eww_widgets.sh;

          gtk = {
            enable = true;
            theme = {
              name = "Catppuccin-Mocha-Compact-Mauve-Dark";
              package = pkgs.catppuccin-gtk.override {
                accents = ["mauve"];
                size = "compact";
                # tweaks = ["rimless" "black"];
                variant = "mocha";
              };
            };
          };

          xdg.configFile."foot/foot.ini".source = ./foot.ini;

          xdg.configFile."eww".source = inputs.internalFlakes.desktop.hyprland-rice.eww-config;

          xdg.configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;
          xdg.configFile."hypr/wallpaper.jpg".source = ./wallpaper.jpg;
          xdg.configFile."wal/colorschemes/dark/turtle-snail.json".source = ./turtle-snail.json;
          xdg.configFile."wofi/style.css".source = ./style.css;

          services.mako = {
            enable = true;
            anchor = "top-right";
            defaultTimeout = 4000;
            ignoreTimeout = true;
            backgroundColor = "#1e1e2e";
            borderColor = "#cba6f7";
            textColor = "#cdd6f4";
            borderRadius = 12;
            progressColor = "#cba6f7";
          };
        };

        # Pls make this shell-independent
        programs.zsh.shellInit = "wal --theme turtle-snail -q";

        services.xserver = {
          enable = true;
          displayManager.defaultSession = "hyprland";
          displayManager.sddm = {
            enable = true;
            theme = "catppuccin-mocha";
          };
        };
      }
    )
  ];
}
