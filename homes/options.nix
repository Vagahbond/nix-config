{lib, ...}: let
  rices = [
    "turtl-snail"
  ];
in {
  options = {
    rice = lib.mkOption {
      type = lib.types.enum (rices ++ [null]);
      default = null;
      description = "Selected rice to use with nix-cooker";
    };
  };
}
