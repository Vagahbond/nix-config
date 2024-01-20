{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  programs.gamescope = {
    enable = true;
    gamescopeSession = {
      enable = true;
    };
  };
}
