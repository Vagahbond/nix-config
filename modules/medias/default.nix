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

  graphics = config.modules.graphics;
  cfg = config.modules.medias;
in {
  options.modules.medias = {
    video = {
      player = mkOption {
        type = types.bool;
        default = true;
        description = "Enable video player (VLC)";
        example = false;
      };

      editor = mkOption {
        type = types.bool;
        default = false;
        description = "Enable video editor (Shotcut)";
        example = false;
      };

      encoder = mkOption {
        type = types.bool;
        default = false;
        description = "Enable video encoder (Handbrake)";
        example = false;
      };

      downloader = mkOption {
        type = types.bool;
        default = false;
        description = "Enable video downloader (youtube-dl, nicotine+)";
        example = false;
      };
    };

    audio = {
      player = mkOption {
        type = types.bool;
        default = false;
        description = "Enable audio player (Spicetify)";
        example = false;
      };

      editor = mkOption {
        type = types.bool;
        default = false;
        description = "Enable audio editor (Audacity)";
        example = false;
      };
    };

    image = {
      viewer = mkOption {
        type = types.bool;
        default = true;
        description = "Enable image viewer (Nomacs)";
        example = false;
      };

      editor = mkOption {
        type = types.bool;
        default = false;
        description = "Enable image editor (GIMP)";
        example = false;
      };
    };
  };

  config = mkMerge [
    (mkIf (cfg.video.player
      && (graphics.type != null)) {
      environment.systemPackages = with pkgs; [
        vlc
      ];
    })
    (mkIf (cfg.video.editor
      && (graphics.type != null)) {
      environment.systemPackages = with pkgs; [
        shotcut
      ];
    })
    (mkIf (cfg.video.encoder) {
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
      environment.systemPackages = with pkgs; [
        playerctl
      ];

      home-manager.users.${username} = {pkgs, ...}: let
        spicePkgs = inputs.internalFlakes.medias.spotify.packages.${pkgs.system}.default;
      in {
        imports = [
          inputs.internalFlakes.medias.spotify.module
        ];

        programs.spicetify = {
          enable = true;
          theme = spicePkgs.themes.Ziro;
          colorScheme = "custom";

          customColorScheme = {
            text = "CBA6F7";
            subtext = "CDD6F4";
            # sidebar-text = "";
            main = "1E1E2E";
            sidebar = "181825";
            player = "11111B";
            card = "313244";
            shadow = "1e1e2e";
            selected-row = "CBA6F7";
            button = "CBA6F7";
            button-active = "6c7086";
            button-disabled = "6E6C7E";
            tab-active = "45475a";
            notification = "313244";
            notification-error = "F28FAD";
            misc = "f38ba8";
          };

          enabledExtensions = with spicePkgs.extensions; [
            fullAppDisplay
            shuffle # shuffle+ (special characters are sanitized out of ext names)
            hidePodcasts
            trashbin
            skipOrPlayLikedSongs
            playlistIcons
            songStats
            genre
          ];
        };
      };
    })
  ];
}
