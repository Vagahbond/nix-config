{
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop;
in {
  config = lib.mkMerge [
    (
      lib.mkIf (lib.lists.any (e: (e == "hyprland")) cfg.sessions) {
        programs = {
          gamescope = {
            enable = true;
          };

          steam.gamescopeSession = {
            enable = true;
          };
        };
      }
    )
  ];
}
