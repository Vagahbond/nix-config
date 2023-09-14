{lib, ...}:
with lib; {
  options.modules.dev = {
    enable = mkEnableOption "Enable dev tools";

    languages = mkOption {
      example = ["android" "c-cpp" "csharp" "nodejs" "rust" "ruby" "nix" "php"];

      type = types.listOf types.str;
      default = [];
      description = ''
        List of languages to install
          possible values: see Example.
      '';
    };

    enableGeo = mkEnableOption "Enable geo tools";

    enableNetwork = mkEnableOption "Enable network tools";
  };
}
