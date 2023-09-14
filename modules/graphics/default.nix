{
  config,
  lib,
  ...
}:
with lib; let
  username = import ../../username.nix;
in {
  imports = [./options.nix];

  config = mkIf (config.modules.graphics.type != null) {
    users.users.${username}.extraGroups = ["video"];
  };

  # My gaming nvidia drivers nightmare will be managed here.
}
