{ lib, ... }:
with lib;
{
  options.modules.terminal = {
    tmux = {
      enable = mkEnableOption "tmux";
    };

    nh = {
      enable = mkEnableOption "nh";
    };

    shell = mkOption {
      type = types.enum [
        "zsh"
        "bash"
      ];
      default = "zsh";
      description = ''
        Select the shell you want to use.

        So far only zsh is available.
      '';
      example = "zsh";
    };

    shellAliases = mkOption {
      type = types.attrs;
      default = { };
      description = ''
        Specific aliases for that system.
      '';
      example = {
        build = "sudo nixos-rebuild build";
      };
    };
  };
}
