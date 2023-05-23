{
  config,
  lib,
  ...
}:
with lib; let
  username = import ../../username.nix;

  cfg = config.modules.graphics;
in {
  options.modules.graphics = {
    type = mkOption {
      # if yours is missing, don't hesitate to PR
      type = types.enum [null "nvidia-optimus" "intel"];
      description = "Enable GUI: all GUI related packages will be installed, as well as drivers if needed.";
      default = null;
      example = "intel";
    };
  };

  config =
    {}
    // mkIf (config.modules.graphics.type != null) {
      users.users.${username}.extraGroups = ["video"];
    };

  # My gaming nvidia drivers nightmare will be managed here.
}
