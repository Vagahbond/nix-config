# Some general immutable options for all hosts
{
  pkgs,
  self,
  config,
  inputs,
  lib,
  ...
}: let
  #   docs = import ./doc {inherit (pkgs) lib runCommand nixosOptionsDoc;};
  username = import ./username.nix;
in {
  nix = {
  };

}
