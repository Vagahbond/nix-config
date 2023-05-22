{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  user = import ../../username.nix;

  cfg = config.modules.terminal;
in {
  options.modules.terminal = {
    theFuck.enable = mkEnableOption "Enable if you have fat fingers";

    shell = mkOption {
      type = types.enum ["zsh" "shell"];
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

  config =
    {}
    // mkIf cfg.theFuck.enable {
      environment.systemPackages = with pkgs; [
        thefuck
      ];
    }
    // mkIf (cfg.shell == "zsh") {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        ohMyZsh = {
          enable = true;
          plugins = [
            "git"
          ];

          theme = "refined";
        };
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
        shellAliases =
          {
            update = "sudo nixos-rebuild switch --flake ~/vagahbond-dotfiles";
            build = "sudo nixos-rebuild build --flake ~/vagahbond-dotfiles";
          }
          // cfg.shellAliases;
      };

      users.defaultUserShell = pkgs.zsh;
    };
}
