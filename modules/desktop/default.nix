{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.modules.desktop;
  username = import ../../username.nix;
  sddm-themes = pkgs.callPackage ./sddm-themes.nix {};
  inherit (config.modules.impermanence) storageLocation;
in {
  imports = [
    ./options.nix
  ];

  config =
    if (cfg.session != null)
    then
      lib.mkMerge [
        # Default packages for any env
        {
          systemPackages = with pkgs; [
            # For laptop with light sensor
            iio-sensor-proxy
            # For notifications
            libnotify
          ];
          # Gotta have default fonts
          fonts.packages = with pkgs; [
            noto-fonts
            noto-fonts-cjk
            noto-fonts-emoji
          ];
        }
        (
          lib.mkIf ("hyprland" == cfg.session) import ./hyprland.nix {inherit username storageLocation pkgs inputs;}
        )
      ]
    else {};
}
