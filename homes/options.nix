{
  lib,
  types,
}: let
  rices = [
    import
    ./hypr-turtl-snail
  ];

  ricesNames = lib.map (r: r.name) rices;
in {
  options = {
    rice = lib.mkOption {
      type = types.enum ricesNames;
      default = {};
      description = "Selected rice to use with nix-cooker";
    };
  };
}
