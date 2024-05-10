{
  config,
  lib,
}: let
  username = import ../username.nix;

  keys = {
    builder_access = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII15sFe9kG/r6idBuf4IDUOvgdTZ9wsL+KwA76AcJh9g vagahbond@framework";
    platypute_access = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOHltlf+mdcWwHJ7bKcPB+V5xd2aqGLSwd1VSTV8v4Su vagahbond@framework";
    github_access = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBi/qH3wsZVyF61Wd1qgwvzx5VRl4uPYEWNxSCbYLC+n vagahbond@framework";
    dedistonks_access = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPuP+GtAAxcazFzWDVqzV+CLTJXi1IqM4/QfNFukjFXr vagahbond@pm.me";
  };

  mkPrivateKey = name: {
    file = ./${name}.age;
    path = "/home/${username}/.ssh/${name}";
    mode = "600";
    owner = username;
    group = "users";
  };

  mkKeyPair = name: pub: {
    inherit pub name;
    priv = mkPrivateKey name;
  };

  mkKeys = lib.attrsets.foldlAttrs (acc: name: value: acc // {${name} = mkKeyPair name value;}) {};
in
  mkKeys keys
