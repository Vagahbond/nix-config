{
  pkgs,
  lib,
  inputs,
  ...
}: let
  username = import ../../username.nix;
in {
  environment.systemPackages = with pkgs; [
    vlc
    nomacs

    nicotine-plus
    yt-dlp

    shotcut
    gimp
    handbrake
    audacity
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
}
