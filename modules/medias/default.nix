{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
with lib;
let
  # TODO:  Add a spotifyd and better support for gui vs terminal
  username = import ../../username.nix;

  inherit (config.modules) impermanence;
  cfg = config.modules.medias;
in
{
  imports = [
    ./options.nix
  ];
  config = mkMerge [
    (mkIf (cfg.video.player) {
      environment.systemPackages = with pkgs; [
        vlc
        mpv
      ];
    })
    (mkIf (cfg.video.editor) {
      environment.systemPackages = with pkgs; [
        shotcut
      ];
    })
    (mkIf cfg.video.encoder {
      environment.systemPackages = with pkgs; [
        ffmpeg
      ];
    })
    (mkIf (cfg.video.encoder) {
      environment.systemPackages = with pkgs; [
        handbrake
      ];
    })
    (mkIf (cfg.video.downloader) {
      environment.systemPackages = with pkgs; [
        yt-dlp
        nicotine-plus
      ];
    })

    (mkIf (cfg.audio.editor) {
      environment.systemPackages = with pkgs; [
        audacity
      ];
    })
    (mkIf (cfg.image.viewer) {
      environment.systemPackages = with pkgs; [
        nomacs
      ];
    })
    (mkIf (cfg.image.editor) {
      environment.systemPackages = with pkgs; [
        gimp
      ];
    })
    (
      mkIf (cfg.audio.player) {
        environment.systemPackages = with pkgs; [
          playerctl
        ];
      }
      // lib.optionalAttrs (builtins.hasAttr "home-manager" options) {
        home-manager.users.${username} =
          { pkgs, ... }:
          let
            spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
          in
          {
            imports = [
              inputs.spicetify-nix.homeManagerModules.default
            ];

            programs.spicetify = {
              enable = true;
              theme = spicePkgs.themes.text // {
                additonalCss = ''
                  * {
                    font-family: ${config.theme.font.name}; !important
                    font-size: 16px; !important
                  }
                '';
              };
              customColorScheme = config.theme.templates.spicetify;
              enabledExtensions = with spicePkgs.extensions; [
                shuffle # shuffle+ (special characters are sanitized out of ext names)
                adblock
              ];
            };
          };
      }
    )
  ];
}
