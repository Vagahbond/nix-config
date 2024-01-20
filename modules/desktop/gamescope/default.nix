{
  config,
  lib,
  ...
}: let
  cfg = config.modules.desktop;
in {
  config = lib.mkMerge [
    (
      lib.mkIf ("gamescope" == cfg.session) {
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
