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

          gtklock

          colorz
          iio-sensor-proxy

          xfce.tumbler
          libgsf # odf files
          ffmpegthumbnailer
          ark # GUI archiver for thunar archive plugin

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

        environment.etc = {
          # Creates /etc/nanorc
          "pam.d/gtklock" = {
            text = ''
              auth            sufficient      pam_unix.so try_first_pass likeauth nullok
              auth            sufficient      pam_fprintd.so
            '';

            # The UNIX file mode bits
            # mode = "0440";
          };
        };

        fonts.fonts = with pkgs; [
          noto-fonts
          noto-fonts-cjk
          noto-fonts-emoji
          font-awesome
          (nerdfonts.override {fonts = ["CascadiaCode" "FiraCode" "DroidSansMono" "Noto"];})
        ];

        programs = {
          light.enable = true;

          xwayland.enable = true;

          hyprland = {
            enable = true;
            xwayland = {
              enable = true;
              # hdpi = false;
            };

            nvidiaPatches = false;

            package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
          };

          # TODO: make this shell-independent
          zsh.shellInit = "wal --theme turtle-snail -q";
        };

        services = {
          dbus.enable = true;
          xserver = {
            enable = true;
            displayManager.defaultSession = "hyprland";
            displayManager.sddm = {
              enable = true;
              theme = "catppuccin-mocha";
              autoNumlock = true;
            };
          };
        };

        nix.settings = {
          substituters = ["https://hyprland.cachix.org"];
          trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
        };

        # Latest version of Hyprland

        environment.sessionVariables = {
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          SDL_VIDEODRIVER = "wayland";
          GDK_BACKEND = "wayland";
          WLR_NO_HARDWARE_CURSORS = "1";
          MOZ_ENABLE_WAYLAND = "1";
          NIXOS_OZONE_WL = "1";
        };

        home-manager.users.${username} = {
          home = {
            pointerCursor = {
              package = pkgs.catppuccin-cursors.mochaDark; #pkgs.bibata-cursors;
              name = "Catppuccin-Mocha-Dark-Cursors"; #"Bibata-Modern-Classic";
              size = 24;
              gtk.enable = true;
              x11.enable = true;
            };

            packages = with pkgs; [
              glib # gsettings

              (catppuccin-papirus-folders.override {
                accent = "mauve";
                flavor = "mocha";
              })
            ];

            sessionVariables = {
              # set GTK theme as specified by the catppuccin-gtk package
              GTK_THEME = "Catppuccin-Mocha-Compact-Mauve-Dark";

              # gtk applications should use filepickers specified by xdg
              GTK_USE_PORTAL = "1";
            };
          };

          # themes I guess
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

            iconTheme = {
              name = "Papirus-Dark";
              package = pkgs.catppuccin-papirus-folders.override {
                accent = "mauve";
                flavor = "mocha";
              };
            };
          };

          xdg.configFile = {
            "hypr/hyprland.conf".source = ./hyprland.conf;

            # Scripts for eww bar
            "hypr/volume.sh".source = ./volume.sh;
            "hypr/brightness.sh".source = ./brightness.sh;
            "hypr/eww_widgets.sh".source = ./eww_widgets.sh;

            "foot/foot.ini".source = ./foot.ini;

            "eww".source = inputs.internalFlakes.desktop.hyprland-rice.eww-config;

            "hypr/hyprpaper.conf".source = ./hyprpaper.conf;
            "hypr/wallpaper.jpg".source = ./wallpaper.jpg;
            "wal/colorschemes/dark/turtle-snail.json".source = ./turtle-snail.json;
            "wofi/style.css".source = ./style.css;
          };

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
      }
    )
  ];
}
