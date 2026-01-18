{lib, ...}:
with lib; {
  options.modules.dev = {
    enable = mkEnableOption "dev tools";

    languages = mkOption {
      example = ["android" "c-cpp" "csharp" "nodejs" "rust" "ruby" "nix" "php"];

      type = types.listOf types.str;
      default = [];
      description = ''
        List of languages to install
          possible values: see Example.
      '';
    };

    dbManager.enable = mkEnableOption "pgAdmin";

    enableGeo = mkEnableOption "geo tools";

    godot.enable = mkEnableOption "godot";

    enableNetwork = mkEnableOption "network tools";
  };
}
