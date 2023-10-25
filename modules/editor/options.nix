{lib, ...}:
with lib; {
  options.modules.editor = {
    gui = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        List of GUI editors to install (some people like to bloat themselves with seval IDEs)
          possible values: See example.

          WARNING: Ignored if graphics is disabled
      '';
      example = ["vscode"];
    };

    terminal = mkOption {
      type = types.listOf types.str;
      default = ["neovim"];
      description = ''
        List of terminal editors to install (You might wanna test out several editors at the same time)
          possible values: See example.
      '';
      example = ["neovim"];
    };

    office = mkEnableOption "enable LibreOffice";
  };
}
