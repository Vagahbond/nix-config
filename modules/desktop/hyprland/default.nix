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
      mkIf ("hyprland" == cfg.session) {
        # keep sddm data
        environment = {
          persistence.${storageLocation} = {
            directories = [
              "/var/lib/sddm"
            ];
          };

          systemPackages = with pkgs; [
            eww

            hyprpaper

            sddm-themes.catppuccino-sddm

            foot
          ];
        };

        programs = {
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
          displayManager.sddm = {
            enable = true;
            theme = "catppuccin-mocha";
            autoNumlock = true;
            wayland.enable = true;
          };
        };

        nix.settings = {
          substituters = [
            "https://anyrun.cachix.org"
          ];
          trusted-public-keys = [
            "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
          ];
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

          };
          # themes I guess
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
