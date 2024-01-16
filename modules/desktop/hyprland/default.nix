{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
with lib; let
  username = import ../../../username.nix;

  # TODO: Investigate why I did such a thing
  # pywalfox-nixpkgs = builtins.fetchTarball {
  #   url = "https://github.com/nixos/nixpkgs/archive/e213f8c329429cac1715a86eec617a93783bb99c.tar.gz";
  #   sha256 = "sha256:08j1jdy2zdr53m3ir21i92nfg8xz3bjy29xyaqdqh43k3p32xcxn";
  # };

  # pywalfox = pkgs.python3Packages.buildPythonPackage rec {
  #   pname = "pywalfox";
  #   version = "2.7.4";
  #   src = pkgs.python3Packages.fetchPypi {
  #     inherit pname version;
  #     sha256 = "sha256-Wec9fic4lXT7gBY04D2EcfCb/gYoZcrYA/aMRWaA7WY=";
  #  };
  #  doCheck = false;
  #  propagatedBuildInputs = [
  #    # Specify dependencies
  #    # pkgs.python3Packages.numpy
  #  ];
  #};

  isNvidiaEnabled = lib.lists.any (e: (e == config.modules.graphics.type)) ["nvidia-optimus" "nvidia"];

  # pywalfox = pkgs.python310Packages.callPackage "${pywalfox-nixpkgs}/pkgs/development/python-modules/pywalfox/default.nix" {};
  sddm-themes = pkgs.callPackage ./sddm-themes.nix {};
  inherit (inputs) anyrun hyprland;
  inherit (config.modules.impermanence) storageLocation;

  cfg = config.modules.desktop;
in {
  config = mkMerge [
    (
      mkIf (cfg.rice == "hyprland") {
        # keep sddm data
        environment = {
          persistence.${storageLocation} = {
            directories = [
              "/var/lib/sddm"
            ];

            users.${username} = {
              directories = [
                ".cache/wal"
                ".hyprland"
              ];
            };
          };

          systemPackages = with pkgs; [
            wireplumber
            qt6.qtwayland
            libsForQt5.qt5.qtwayland
            hyprshot
            satty
            cliphist
            wl-clipboard

            gtklock

            colorz
            iio-sensor-proxy

            xfce.tumbler
            libgsf # odf files
            ffmpegthumbnailer
            ark # GUI archiver for thunar archive plugin

            eww-wayland

            hyprpaper

            # pywalfox
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

            nitch
          ];

          etc = {
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
        };
        fonts.packages = with pkgs; [
          noto-fonts
          noto-fonts-cjk
          noto-fonts-emoji
          font-awesome
          # testign out fonts for space theme
          (nerdfonts.override {fonts = ["3270" "Terminus" "HeavyData" "ProggyClean" "CascadiaCode" "FiraCode" "DroidSansMono" "Noto"];})
        ];

        xdg.portal = {
          enable = true;
          extraPortals = [
            pkgs.xdg-desktop-portal-gtk
            # inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
          ];
          # TODO look into and make use of this
          config.common.default = "*";
        };
        /*
           xdg.portal = {
          enable = true;
          extraPortals = [
            pkgs.xdg-desktop-portal-gtk
          ];
          config.common = {
            default = "hyprland";
            "org.freedesktop.impl.portal.Screencast" = "hyprland";
            "org.freedesktop.impl.portal.Screenshot" = "hyprland";
            "org.freedesktop.impl.portal.Settings" = "gtk";
            # "org.freedesktop.portal.FileChooser" = "hyprland";
          };
        };
        */
        programs = {
          light.enable = true;

          xwayland.enable = true;

          hyprland = {
            enable = true;
            xwayland = {
              enable = true;
            };
            package = hyprland.packages.${pkgs.system}.hyprland;
          };
          thunar = {
            enable = true;
            plugins = with pkgs.xfce; [
              thunar-archive-plugin
              thunar-media-tags-plugin
            ];
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
          substituters = [
            "https://hyprland.cachix.org"
            "https://anyrun.cachix.org"
            "https://nix-gaming.cachix.org"
          ];
          trusted-public-keys = [
            "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
          ];
        };
        # Latest version of Hyprland

        environment.sessionVariables = {
          # scaling - 1 means no scaling
          QT_AUTO_SCREEN_SCALE_FACTOR = "1";

          # use wayland as the default backend, fallback to xcb if wayland is not available
          QT_QPA_PLATFORM = "wayland;xcb";

          # disable window decorations everywhere
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

          # remain backwards compatible with qt5
          DISABLE_QT5_COMPAT = "0";

          # tell calibre to use the dark theme, because the light one hurts my eyes
          CALIBRE_USE_DARK_PALETTE = "1";
          SDL_VIDEODRIVER = "wayland";
          GDK_BACKEND = "wayland";
          WLR_NO_HARDWARE_CURSORS = "1";
          MOZ_ENABLE_WAYLAND = "1";
          NIXOS_OZONE_WL = "1";

          # set GTK theme as specified by the catppuccin-gtk package
          GTK_THEME = "Catppuccin-Mocha-Standard-Mauve-Dark";

          # gtk applications should use filepickers specified by xdg
          GTK_USE_PORTAL = "1";
        };

        home-manager.users.${username} = let
          m-catppuccin-gtk = pkgs.catppuccin-gtk.override {
            accents = ["mauve"];
            size = "standard";
            variant = "mocha";
            tweaks = ["normal"];
          };
        in {
          imports = [anyrun.homeManagerModules.default];
          programs.anyrun = {
            enable = true;
            config = {
              plugins = with inputs.anyrun.packages.${pkgs.system}; [
                applications
                rink
                randr
                websearch
                shell
                # symbols
                translate
                dictionary
                # inputs.anyrun-nixos-options.packages.${pkgs.system}.default
              ];
              # position = "top";
              y.fraction = 0.3;
              width.fraction = 0.3;
              closeOnClick = true;
              hidePluginInfo = true;
              showResultsImmediately = true;
              maxEntries = 10;
              hideIcons = false;
              ignoreExclusiveZones = false;
              layer = "overlay";
            };
            extraCss = ''
              * {
                font-family: Terminess Nerd Font;
              }

              window {
                background-color: rgba(0, 0, 0, 0.5);
              }

              #match,
              #entry,
              #plugin,
              #main {
                border-radius: 14px;

              }

              #match.activatable {
              }

              #match.activatable:not(:first-child) {
              }

              #match.activatable #match-title {
              }

              #match.activatable:hover {
              }

              #match-title, #match-desc {
              }

              #match.activatable:hover, #match.activatable:selected {
                border-radius: 14px;
              }

              #match.activatable:selected + #match.activatable, #match.activatable:hover + #match.activatable {
              }

              #match.activatable:selected, #match.activatable:hover:selected {
              }

              #match, #plugin {
                border-radius: 14px;
              }

              #entry {
                background-color: rgb(49, 50, 68);
                margin-bottom: 10px;
              }

              box#main {
              }

              row:first-child {
              }
            '';
            extraConfigFiles = {
              /*
                "nixos-options.ron".text = let
                nixos-options = config.system.build.manual.optionsJSON + "/share/doc/nixos/options.json";
                hm-options = inputs.home-manager.packages.${pkgs.system}.docs-json + "/share/doc/home-manager/options.json";
                options = builtins.toJSON {
                  ":nix" = [nixos-options];
                  ":hm" = [hm-options];
                };
              in ''
                Config(
                  options: ${options},
                  max_entries: 5
                )
              '';
              */
              "dictionary.ron".text = ''
                Config(
                  prefix: ":def",
                )
              '';
              "randr.ron".text = ''
                Config(
                  prefix: ":dp",
                )
              '';
              "applications.ron".text = ''
                Config(
                  desktop_actions: true,
                  max_entries: 10,
                )
              '';
              "websearch.ron".text = ''
                Config(
                  prefix: "?",
                  engines: [
                    DuckDuckGo,
                    Custom(
                      name: "nix packages",
                      url: "search.nixos.org/packages?query={}&channel=unstable",
                    ),
                  ],
                )
              '';
            };
          };

          home = {
            pointerCursor = {
              package = pkgs.catppuccin-cursors.mochaDark;
              name = "Catppuccin-Mocha-Dark-Cursors";
              size = 24;
              gtk.enable = true;
              x11.enable = true;
            };

            packages = with pkgs; [
              glib # gsettings
              m-catppuccin-gtk
            ];
          };
          # themes I guess
          gtk = {
            enable = true;
            theme = {
              name = "Catppuccin-Mocha-Standard-Mauve-Dark";
              package = m-catppuccin-gtk;
            };

            iconTheme = {
              name = "Papirus-Dark";
              package = pkgs.catppuccin-papirus-folders.override {
                accent = "mauve";
                flavor = "mocha";
              };
            };

            font = {
              name = "Terminess Nerd Font";
              size = 14;
            };
            gtk4.extraConfig = {
              gtk-application-prefer-dark-theme = 1;
            };

            gtk3.extraConfig = {
              gtk-xft-antialias = 1;
              gtk-xft-hinting = 1;
              gtk-xft-hintstyle = "hintslight";
              gtk-xft-rgba = "rgb";
              gtk-application-prefer-dark-theme = 1;
            };

            gtk2 = {
              # configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
              extraConfig = ''
                gtk-xft-antialias=1
                gtk-xft-hinting=1
                gtk-xft-hintstyle="hintslight"
                gtk-xft-rgba="rgb"
              '';
            };
          };

          xdg.configFile = {
            "hypr/hyprland.conf".text = import ./hyprland.conf.nix {inherit config lib;};

            # Scripts for eww bar
            "hypr/volume.sh".source = ./volume.sh;
            "hypr/brightness.sh".source = ./brightness.sh;
            "hypr/eww_widgets.sh".source = ./eww_widgets.sh;

            "foot/foot.ini".source = ./foot.ini;

            "eww".source = inputs.eww-config;

            "hypr/hyprpaper.conf".source = ./hyprpaper.conf;
            "hypr/wallpaper.jpg".source = ./wallpaper.jpg;
            "wal/colorschemes/dark/turtle-snail.json".source = ./turtle-snail.json;
            "wofi/style.css".source = ./style.css;

            "kdeglobals".source = "${config.home-manager.users.${username}.qt.style.package}/share/color-schemes/CatppuccinMochaMauve.colors";

            "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
              General.theme = "catppuccin";
              Applications.catppuccin = ''
                qt5ct, org.qbittorrent.qBittorrent, hyprland-share-picker, dolphin-emu, Nextcloud, nextcloud, cantata, org.kde.kid3-qt
              '';
            };

            "Kvantum/catppuccin/catppuccin.kvconfig".source = builtins.fetchurl {
              url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Mauve/Catppuccin-Mocha-Mauve.kvconfig";
              sha256 = "sha256:1hwb6j5xjkmnsi55c6hsdwcn8r4n4cisfbsfya68j4dq5nj0z3r6";
            };

            "Kvantum/catppuccin/catppuccin.svg".source = builtins.fetchurl {
              url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Mauve/Catppuccin-Mocha-Mauve.svg";
              sha256 = "sha256:06w5nfp89v1zzzrxm38i77wpfrvbknfzjrrnsixw7r1ljk017ijh";
            };
          };
          qt = {
            enable = true;
            platformTheme = "gtk"; # just an override for QT_QPA_PLATFORMTHEME, takes “gtk”, “gnome”, “qtct” or “kde”
            style = {
              name = "Catppuccin-Mocha-Dark";
              package = pkgs.catppuccin-kde.override {
                flavour = ["mocha"];
                accents = ["mauve"];
                winDecStyles = ["modern"];
              };
            };
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
