{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop;
  username = import ../../../username.nix;
in {
  config = lib.mkMerge [
    (
      lib.mkIf ("gnome" == cfg.session) {
        hardware.pulseaudio.enable = lib.mkForce false;

        networking.wireless.enable = lib.mkForce false;

        environment.gnome.excludePackages =
          (with pkgs; [
            gnome-photos
            gnome-tour
          ])
          ++ (with pkgs.gnome; [
            cheese # webcam tool
            # gnome-music
            # gnome-terminal
            # gedit # text editor
            # epiphany # web browser
            geary # email reader
            evince # document viewer
            gnome-characters
            # totem # video player
            # tali # poker game
            # iagno # go game
            # hitori # sudoku game
            # atomix # puzzle game
          ]);

        services = {
          xserver = {
            enable = true;
            displayManager.gdm.enable = true;
            desktopManager.gnome.enable = true;
          };
        };

        home-manager.users.${username} = {
          dconf = {
            enable = true;
            settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
          };
        };
      }
    )
  ];
}
