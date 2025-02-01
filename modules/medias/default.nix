{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
with lib; let
  # TODO:  Add a spotifyd and better support for gui vs terminal
  username = import ../../username.nix;

  inherit (config.modules) graphics impermanence;
  cfg = config.modules.medias;
in {
  imports = [
    ./options.nix
  ];
  config = mkMerge [
    (mkIf (cfg.video.player
      && (graphics.type != null)) {
      environment.systemPackages = with pkgs; [
        vlc
        mpv
      ];
    })
    (mkIf (cfg.video.editor
      && (graphics.type != null)) {
      environment.systemPackages = with pkgs; [
        shotcut
      ];
    })
    (mkIf cfg.video.encoder {
      environment.systemPackages = with pkgs; [
        ffmpeg
      ];
    })
    (mkIf (cfg.video.encoder
      && (graphics.type != null)) {
      environment.systemPackages = with pkgs; [
        handbrake
      ];
    })
    (mkIf (cfg.video.downloader
      && (graphics.type != null)) {
      environment.systemPackages = with pkgs; [
        yt-dlp
        nicotine-plus
      ];
    })
    (mkIf (cfg.video.recorder
      && (graphics.type != null)) {
      environment.persistence.${impermanence.storageLocation} = {
        users.${username} = {
          directories = [
            ".config/obs-studio"
          ];
        };
      };

      environment.systemPackages = with pkgs; [
        kooha
        (wrapOBS {
          plugins = with obs-studio-plugins; [
            wlrobs
            obs-backgroundremoval
            obs-pipewire-audio-capture
          ];
        })
      ];
    })
    (mkIf (cfg.audio.editor
      && (graphics.type != null)) {
      environment.systemPackages = with pkgs; [
        audacity
      ];
    })
    (mkIf (cfg.image.viewer
      && (graphics.type != null)) {
      environment.systemPackages = with pkgs; [
        nomacs
      ];
    })
    (mkIf (cfg.image.editor
      && (graphics.type != null)) {
      environment.systemPackages = with pkgs; [
        gimp
      ];
    })
    (mkIf (cfg.audio.player
      && (graphics.type != null)) {
      environment.persistence.${impermanence.storageLocation} = {
        users.${username} = {
          directories = [
            ".config/spotify"
          ];
          files = [
          ];
        };
      };

      environment.systemPackages = with pkgs; [
        playerctl
      ];

      home-manager.users.${username} = {pkgs, ...}: let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
      in {
        imports = [
          inputs.spicetify-nix.homeManagerModules.default
        ];

        programs.spicetify = {
          enable = true;
          theme = spicePkgs.themes.text;
          /*
            // {
            additonalCss = ''
              * {
                font-family: ${config.theme.font.name};
                font-size: 16px;
              }
            ''
          };
          */
          customColorScheme = config.theme.templates.spicetify;
          enabledExtensions = with spicePkgs.extensions; [
            shuffle # shuffle+ (special characters are sanitized out of ext names)
            hidePodcasts
            adblock
          ];
        };
      };
    })
  ];
}
