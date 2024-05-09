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

    enableGeo = mkEnableOption "geo tools";

    enableNetwork = mkEnableOption "network tools";
  };
}
