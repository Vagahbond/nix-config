{
  lib,
  options,
  specialArgs,
  config,
  modulesPath,
  ...
}: let
  username = ../../username.nix;
in {
  imports = [
    ../../modules
  ];

  age.identityPaths = [
    "/home/${username}/.ssh/*"
  ];
}
