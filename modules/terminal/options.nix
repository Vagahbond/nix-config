{lib, ...}:
with lib; {
  options.modules.terminal = {
    theFuck.enable = mkEnableOption "Enable if you have fat fingers";

    tmux = {
      enable = mkEnableOption "tmux";
    };

    shell = mkOption {
      type = types.enum ["zsh" "bash"];
      default = "zsh";
      description = ''
        Select the shell you want to use.

        So far only zsh is available.
      '';
      example = "zsh";
    };

    shellAliases = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        Specific aliases for that system.
      '';
      example = {
        build = "sudo nixos-rebuild build";
      };
    };
  };
}
